package com.tomtom.flutter_tomtom_navigation_android

import android.Manifest
import android.content.Context
import android.content.ContextWrapper
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.core.view.doOnAttach
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import com.tomtom.flutter_tomtom_navigation_android.platform_channel.BasicEventPublisher
import com.tomtom.flutter_tomtom_navigation_android.platform_channel.DestinationArrivalPublisher
import com.tomtom.flutter_tomtom_navigation_android.platform_channel.NativeEventPublisher
import com.tomtom.flutter_tomtom_navigation_android.platform_channel.NavigationStatusPublisher
import com.tomtom.quantity.Distance
import com.tomtom.sdk.datamanagement.navigationtile.NavigationTileStore
import com.tomtom.sdk.datamanagement.navigationtile.NavigationTileStoreConfiguration
import com.tomtom.sdk.datamanagement.navigationtile.PrefetchingConfiguration
import com.tomtom.sdk.location.GeoLocation
import com.tomtom.sdk.location.LocationProvider
import com.tomtom.sdk.location.OnLocationUpdateListener
import com.tomtom.sdk.location.android.AndroidLocationProvider
import com.tomtom.sdk.location.simulation.SimulationLocationProvider
import com.tomtom.sdk.location.simulation.strategy.InterpolationStrategy
import com.tomtom.sdk.map.display.TomTomMap
import com.tomtom.sdk.map.display.camera.CameraTrackingMode
import com.tomtom.sdk.map.display.common.screen.Padding
import com.tomtom.sdk.map.display.location.LocationMarkerOptions
import com.tomtom.sdk.map.display.style.LoadingStyleFailure
import com.tomtom.sdk.map.display.style.StandardStyles
import com.tomtom.sdk.map.display.style.StyleLoadingCallback
import com.tomtom.sdk.map.display.ui.MapFragment
import com.tomtom.sdk.map.display.visualization.navigation.NavigationVisualization
import com.tomtom.sdk.map.display.visualization.navigation.NavigationVisualizationFactory
import com.tomtom.sdk.map.display.visualization.navigation.StyleConfiguration
import com.tomtom.sdk.map.display.visualization.routing.RoutePlan
import com.tomtom.sdk.map.display.visualization.routing.traffic.RouteTrafficIncidentStyle
import com.tomtom.sdk.navigation.TomTomNavigation
import com.tomtom.sdk.navigation.online.Configuration
import com.tomtom.sdk.navigation.online.OnlineTomTomNavigationFactory
import com.tomtom.sdk.navigation.ui.NavigationFragment
import com.tomtom.sdk.navigation.ui.NavigationUiOptions
import com.tomtom.sdk.routing.RoutePlanner
import com.tomtom.sdk.routing.RoutePlanningCallback
import com.tomtom.sdk.routing.RoutePlanningResponse
import com.tomtom.sdk.routing.RoutingFailure
import com.tomtom.sdk.routing.online.OnlineRoutePlanner
import com.tomtom.sdk.routing.route.Route
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.VehicleProvider
import com.tomtom.sdk.vehicle.VehicleProviderFactory
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import java.util.Locale
import kotlin.random.Random


/**
 * The FlutterTomtomNavigationView provides an all-in-one View that is displayed
 * through a Flutter platform view, and handles map display and navigation using
 * the native TomTom Android Maps and Navigation SDKs.
 */
class FlutterTomtomNavigationView(
    private val context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?
) : PlatformView, MethodCallHandler {
    /**
     * The TomTom API key which is passed in the initial MapOptions.
     */
    private val apiKey: String
    private val channel: MethodChannel
    private val navigationStatusPublisher: NavigationStatusPublisher
    private val routeUpdatePublisher: BasicEventPublisher
    private val locationUpdatePublisher: BasicEventPublisher
    private val routePlannedPublisher: BasicEventPublisher
    private val progressUpdatedPublisher: BasicEventPublisher
    private val destinationArrivalPublisher: DestinationArrivalPublisher

    /**
     * The view that the TomTom fragments get added to, and that is rendered.
     */
    private val view = ConstraintLayout(context)

    // SDK objects
    private val navigationFragment: NavigationFragment
    private val locationProvider: LocationProvider
    private val navigationTileStore: NavigationTileStore
    private val routePlanner: RoutePlanner
    private val tomTomNavigation: TomTomNavigation
    private val vehicleProvider: VehicleProvider

    // navigation visualization and tomTomMap are nullable because they can only be initialized after we get the TomTomMap object.
    private var tomTomMap: TomTomMap? = null
    private var navigationVisualization: NavigationVisualization? = null
    private var routePlan: com.tomtom.sdk.navigation.RoutePlan? = null
    private var simLocationProvider: LocationProvider? = null
    private var route: Route? = null

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
        navigationVisualization?.close()
        tomTomNavigation.close()
        navigationTileStore.close()
        routePlanner.close()
    }

    init {
        println("Init navigation view with id $id")

        if (creationParams.isNullOrEmpty()) {
            throw IllegalArgumentException("No creation parameters provided to the FlutterTomtomNavigationView")
        }

        // Get the API key from the creation params
        val mapOptionsJson = creationParams["mapOptions"] as String
        val mapOptions = MapOptionsDeserializer.deserialize(mapOptionsJson)
        apiKey = mapOptions.mapKey

        // Get the binary messenger from the creation params
        val binaryMessenger =
            creationParams["binaryMessenger"] as BinaryMessenger
        channel = MethodChannel(binaryMessenger, "flutter_tomtom_navigation")
        channel.setMethodCallHandler(this)

        // Get the publish method from the creation params and initialize the publishers
        @Suppress("UNCHECKED_CAST")
        val publish = creationParams["publish"] as (String) -> (Unit)
        navigationStatusPublisher = NavigationStatusPublisher(publish)
        routeUpdatePublisher = BasicEventPublisher(
            publish,
            NativeEventPublisher.NativeEventType.ROUTE_UPDATE
        )
        locationUpdatePublisher = BasicEventPublisher(
            publish,
            NativeEventPublisher.NativeEventType.LOCATION_UPDATE
        )
        routePlannedPublisher = BasicEventPublisher(
            publish,
            NativeEventPublisher.NativeEventType.ROUTE_PLANNED
        )
        progressUpdatedPublisher = BasicEventPublisher(
            publish,
            NativeEventPublisher.NativeEventType.ROUTE_UPDATE
        )
        destinationArrivalPublisher = DestinationArrivalPublisher(publish)

        navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.INITIALIZING)

        // Initialize required SDK components
        locationProvider = AndroidLocationProvider(context)
        val onLocationUpdateListener = OnLocationUpdateListener { location ->
            locationUpdatePublisher.publish(location)
        }
        locationProvider.addOnLocationUpdateListener(onLocationUpdateListener)

        routePlanner = OnlineRoutePlanner.create(context, apiKey)
        navigationTileStore = NavigationTileStore.create(
            context,
            NavigationTileStoreConfiguration(
                apiKey = apiKey,
                prefetchingConfiguration = PrefetchingConfiguration(
                    prefetchedAreaRadius = Distance.Companion.kilometers(15)
                )
            ),
        )
        vehicleProvider = VehicleProviderFactory.create(Vehicle.Car())
        tomTomNavigation = OnlineTomTomNavigationFactory.create(
            Configuration(
                context = context,
                navigationTileStore = navigationTileStore,
                locationProvider = locationProvider,
                routePlanner = routePlanner,
                // Initialize the TomTomNavigation with a default car. After route planning, it should be updated!
                vehicleProvider = vehicleProvider,
//                safetyLocationsConfiguration = SafetyLocationsConfiguration(apiKey)
            )
        )

        // Add the map container
        val mapFragment = MapFragment.newInstance(mapOptions)
        val mapView = FragmentContainerView(context)
        mapView.id = Random.nextInt()
        view.addView(mapView)
        mapView.doOnAttach {
            // When it is first attached, add the actual map fragment
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, mapFragment)?.commit()
        }

        // Add the navigation container
        navigationFragment =
            NavigationFragment.newInstance(NavigationUiOptions())
        val navigationView = FragmentContainerView(context)
        navigationView.id = Random.nextInt()
        navigationView.foregroundGravity = Gravity.BOTTOM
        val params = ConstraintLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        navigationView.layoutParams = params
        view.addView(navigationView)
        navigationView.doOnAttach {
            // When it is first attached, add the actual navigation fragment
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, navigationFragment)?.commit()
            // TODO one frame is drawn with the speed view shown. Can we hide that somehow?
            Handler(Looper.getMainLooper()).post {
                navigationFragment.setTomTomNavigation(tomTomNavigation)
                navigationFragment.navigationView.hideSpeedView()
                navigationFragment.changeAudioLanguage(Locale.getDefault())
                navigationFragment.addNavigationListener(navigationListener)
                tomTomNavigation.addProgressUpdatedListener { progress ->
                    progressUpdatedPublisher.publish(
                        progress
                    )
                }
                tomTomNavigation.addDestinationArrivalListener { route ->
                    destinationArrivalPublisher.publish(route)
                    navigationVisualization?.clearRoutePlan()
                }
            }
        }
        navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.MAP_LOADED)

        mapFragment.getMapAsync {
            tomTomMap = it

            it.setLocationProvider(locationProvider)
            val locationMarker =
                LocationMarkerOptions(type = LocationMarkerOptions.Type.Pointer)
            it.enableLocationMarker(locationMarker)

            // Create the navigation visualization
            navigationVisualization = NavigationVisualizationFactory.create(
                it,
                tomTomNavigation,
                styleConfiguration = StyleConfiguration(
                    routeTrafficIncident = RouteTrafficIncidentStyle(),
                    // safetyLocationStyle = SafetyLocationStyle(),
                ),
            )

            // Set the map to the vehicle restrictions mode (for now, of the default vehicle)
            it.loadStyle(
                StandardStyles.VEHICLE_RESTRICTIONS,
                object : StyleLoadingCallback {
                    override fun onFailure(failure: LoadingStyleFailure) {
                        println("Failed to load vehicle restrictions!")
                    }

                    override fun onSuccess() {
                        navigationStatusPublisher.publish(
                            NavigationStatusPublisher.NavigationStatus.READY
                        )
                        it.hideVehicleRestrictions()
                    }

                })
            navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.RESTRICTIONS_LOADED)

            // Not sure what we can even do without location, but let's at least check...
            val hasLocationPermissions = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
            if (hasLocationPermissions) {
                locationProvider.enable()
            } else {
                println("No location permissions! We can't really do anything now :(")
            }
        }
    }

    /**
     * Helper function to retrieve the parent fragment activity.
     * It can be used to swap in the required views
     */
    private fun Context.getFragmentActivityOrThrow(): FragmentActivity {
        if (this is FragmentActivity) {
            return this
        }

        var currentContext = this
        while (currentContext is ContextWrapper) {
            if (currentContext is FragmentActivity) {
                return currentContext
            }
            currentContext = currentContext.baseContext
        }

        throw IllegalStateException("Unable to find activity")
    }

    /**
     * Handle the updates to the navigation states using the NavigationListener
     * - Use CameraChangeListener to observe camera tracking mode and detect if the camera is locked on the chevron. If the user starts to move the camera, it will change and you can adjust the UI to suit.
     * - Use the SimulationLocationProvider for testing purposes.
     * - Once navigation is started, the camera is set to follow the user position, and the location indicator is changed to a chevron. To match raw location updates to the routes, use MapMatchedLocationProvider and set it to the TomTomMap.
     * - Set the bottom padding on the map. The padding sets a safe area of the MapView in which user interaction is not received. It is used to uncover the chevron in the navigation panel.
     */
    private val navigationListener =
        object : NavigationFragment.NavigationListener {
            override fun onStarted() {
                println("navigation started")
                navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.RUNNING)

//                tomTomMap.addCameraChangeListener(cameraChangeListener)
                tomTomMap?.cameraTrackingMode =
                    CameraTrackingMode.FollowRouteDirection
                tomTomMap?.enableLocationMarker(
                    LocationMarkerOptions(
                        LocationMarkerOptions.Type.Chevron
                    )
                )

                println("Setting map padding!")
                val bottomPaddingInDp = 263
                val bottomPaddingInPixels =
                    (bottomPaddingInDp * context.resources.displayMetrics.density).toInt()
                val padding = Padding(0, 0, 0, bottomPaddingInPixels)
                tomTomMap?.setPadding(padding)

//                navigationFragment.navigationView.setCurrentSpeedClickListener(
//                    setCurrentSpeedClickListener
//                )
//                tomTomMap.addRouteClickListener(routeClickListener)

//                setMapMatchedLocationProvider()
//                setLocationProviderToNavigation()
//                setMapNavigationPadding()
            }

            override fun onStopped() {
                navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.STOPPED)
                println("stopped!")
                stopNavigation()
            }
        }

    /**
     * Stop the navigation process using NavigationFragment.
     * This hides the UI elements and calls the TomTomNavigation.stop() method.
     * Don’t forget to reset any map settings that were changed, such as camera tracking, location marker, and map padding.
     */
    private fun stopNavigation() {
        tomTomMap?.setPadding(Padding(0, 0, 0, 0))
//        tomTomMap.removeRouteClickListener(routeClickListener)
        navigationFragment.stopNavigation()
        navigationVisualization?.clearRoutePlan()
//        mapFragment.currentLocationButton.visibilityPolicy =
//            CurrentLocationButton.VisibilityPolicy.InvisibleWhen Re-centered
//        tomTomMap.removeCameraChangeListener(cameraChangeListener)
        tomTomMap?.cameraTrackingMode = CameraTrackingMode.None
        tomTomMap?.enableLocationMarker(
            LocationMarkerOptions(
                LocationMarkerOptions.Type.Pointer
            )
        )

        // Set the location provider back to the native one
        closeAndDisposeSimLocationProvider()

        navigationFragment.navigationView.hideSpeedView()
        tomTomMap?.loadStyle(
            StandardStyles.VEHICLE_RESTRICTIONS,
            object : StyleLoadingCallback {
                override fun onFailure(failure: LoadingStyleFailure) {
                    println("Failed to load vehicle restrictions!")
                }

                override fun onSuccess() {
                    navigationStatusPublisher.publish(
                        NavigationStatusPublisher.NavigationStatus.READY
                    )
                    tomTomMap?.hideVehicleRestrictions()
                }

            })
    }

    /**
     * Set the location provider back to the native one.
     */
    private fun closeAndDisposeSimLocationProvider() {
        if (simLocationProvider != null) {
            // Set back to native
            tomTomNavigation.locationProvider = locationProvider
            tomTomMap?.setLocationProvider(locationProvider)

            // Close and dispose the simulated one
            simLocationProvider?.disable()
            simLocationProvider?.close()
            simLocationProvider = null
        }
    }

//    private var previousZoom = 0.0
//
//    private val cameraChangeListener = CameraChangeListener {
//        val cameraTrackingMode = tomTomMap.cameraTrackingMode
//        val zoom = tomTomMap.cameraPosition.zoom
//
//        // If the user zooms out, unlock the camera
//        // Ideally panning would also be allowed while zoomed in, but what can ya do ¯\_(ツ)_/¯
//        // The previous zoom check is so we only toggle to free cam while we're not currently zooming back in to track the route
//        if (zoom <= 14.5 && cameraTrackingMode == CameraTrackingMode.FollowRouteDirection && previousZoom > zoom) {
//            tomTomMap.cameraTrackingMode = CameraTrackingMode.None
//            tomTomMap.animateCamera(
//                CameraOptions(
//                    position = tomTomMap.currentLocation?.position,
//                    tilt = 0.0,
//                    rotation = 0.0,
//                )
//            )
//        }
//
//        previousZoom = zoom
//    }

    /**
     * Handle different method calls from Flutter to the navigation view.
     */
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        println("Called method ${call.method}...")

        when (call.method) {
            "planRoute" -> {
                // We want to plan a route. For this we need to:
                // 1. Get the route planning options and insert the current location as the origin
                // 2. Set the vehicle in TomTomNavigation to this vehicle (for re-planning!)
                // 3. Show the correct restrictions for this vehicle (for visualization)
                val userLocation =
                    tomTomMap?.currentLocation?.position ?: return
                val routePlanningOptions =
                    RoutePlanningOptionsDeserializer.deserialize(
                        call.arguments as String,
                        userLocation
                    )

                tomTomMap?.clear()
                tomTomMap?.hideVehicleRestrictions()

                // Show the vehicle restrictions that apply for the current vehicle
                tomTomMap?.showVehicleRestrictions(routePlanningOptions.vehicle)

                // Update the vehicle in the navigation
                vehicleProvider.vehicle = routePlanningOptions.vehicle

                routePlanner.planRoute(
                    routePlanningOptions,
                    object : RoutePlanningCallback {
                        override fun onSuccess(result: RoutePlanningResponse) {
                            val firstRoute = result.routes.first()
                            route = firstRoute
                            routePlannedPublisher.publish(firstRoute.summary)

                            navigationVisualization?.displayRoutePlan(
                                RoutePlan(result.routes)
                            )
                            navigationVisualization?.selectRoute(firstRoute.id)
                            routePlan = com.tomtom.sdk.navigation.RoutePlan(
                                firstRoute,
                                routePlanningOptions
                            )
                            tomTomMap?.zoomToRoutes(100)
                        }

                        override fun onFailure(failure: RoutingFailure) {
                            Toast.makeText(
                                context,
                                failure.message,
                                Toast.LENGTH_SHORT
                            ).show()
                        }

                        override fun onRoutePlanned(route: Route) = Unit
                    }
                )
            }

            "startNavigation" -> {
                val useSimulation =
                    call.argument<Boolean>("useSimulation")!!

                if (route != null && useSimulation) {
                    val strategy = InterpolationStrategy(route!!.geometry.map {
                        GeoLocation(it)
                    })
                    simLocationProvider =
                        SimulationLocationProvider.create(strategy)
                    tomTomNavigation.locationProvider = simLocationProvider!!
                    tomTomMap?.setLocationProvider(simLocationProvider)
                    simLocationProvider?.enable()
                }
                navigationFragment.navigationView.showSpeedView()

                tomTomMap?.loadStyle(
                    StandardStyles.DRIVING,
                    object : StyleLoadingCallback {
                        override fun onFailure(failure: LoadingStyleFailure) {
                            println("Failed to load driving map style :(")
                        }

                        override fun onSuccess() {
                            if (routePlan != null) {
                                navigationFragment.startNavigation(routePlan!!)
                            }
                        }
                    }
                )
            }

            "stopNavigation" -> {
                stopNavigation()
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
