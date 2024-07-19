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
import com.tomtom.sdk.location.mapmatched.MapMatchedLocationProvider
import com.tomtom.sdk.location.simulation.SimulationLocationProvider
import com.tomtom.sdk.location.simulation.strategy.InterpolationStrategy
import com.tomtom.sdk.map.display.TomTomMap
import com.tomtom.sdk.map.display.camera.CameraTrackingMode
import com.tomtom.sdk.map.display.common.screen.Padding
import com.tomtom.sdk.map.display.gesture.MapPanningListener
import com.tomtom.sdk.map.display.location.LocationMarkerOptions
import com.tomtom.sdk.map.display.style.LoadingStyleFailure
import com.tomtom.sdk.map.display.style.StandardStyles
import com.tomtom.sdk.map.display.style.StyleLoadingCallback
import com.tomtom.sdk.map.display.ui.MapFragment
import com.tomtom.sdk.map.display.ui.Margin
import com.tomtom.sdk.map.display.visualization.navigation.NavigationVisualization
import com.tomtom.sdk.map.display.visualization.navigation.NavigationVisualizationFactory
import com.tomtom.sdk.map.display.visualization.navigation.StyleConfiguration
import com.tomtom.sdk.map.display.visualization.navigation.horizon.safetylocation.SafetyLocationStyle
import com.tomtom.sdk.map.display.visualization.routing.RoutePlan
import com.tomtom.sdk.map.display.visualization.routing.traffic.RouteTrafficIncidentStyle
import com.tomtom.sdk.navigation.GuidanceUpdatedListener
import com.tomtom.sdk.navigation.TomTomNavigation
import com.tomtom.sdk.navigation.guidance.GuidanceAnnouncement
import com.tomtom.sdk.navigation.guidance.InstructionPhase
import com.tomtom.sdk.navigation.guidance.instruction.GuidanceInstruction
import com.tomtom.sdk.navigation.online.Configuration
import com.tomtom.sdk.navigation.online.OnlineTomTomNavigationFactory
import com.tomtom.sdk.navigation.ui.NavigationFragment
import com.tomtom.sdk.navigation.ui.NavigationUiOptions
import com.tomtom.sdk.routing.RoutePlanner
import com.tomtom.sdk.routing.RoutePlanningCallback
import com.tomtom.sdk.routing.RoutePlanningResponse
import com.tomtom.sdk.routing.RoutingFailure
import com.tomtom.sdk.routing.online.OnlineRoutePlanner
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.route.Route
import com.tomtom.sdk.safetylocations.common.SafetyLocationsConfiguration
import com.tomtom.sdk.tts.android.AndroidTextToSpeechEngine
import com.tomtom.sdk.tts.engine.AudioMessage
import com.tomtom.sdk.tts.engine.MessagePlaybackListener
import com.tomtom.sdk.tts.engine.MessageType
import com.tomtom.sdk.tts.engine.TextToSpeechEngineError
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

    /**
     * The method channel which is used to communicate to Flutter.
     *
     * It is used by the different publishers below.
     */
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
    private val mapFragment: MapFragment
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
    private var navLocationProvider: LocationProvider? = null
    private var defaultCurrentLocationButtonMargin: Margin? = null

    // Routes which have been computed by the route planner
    private var routePlanningOptions: RoutePlanningOptions? = null
    private var routes: List<Route>?  = null

    private val density = context.resources.displayMetrics.density

    private var closing = false

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        closing = true
        channel.setMethodCallHandler(null)
        // The visualization etc. are closed implicitly already.
        // If you close them here, an exception is thrown (illegal state: instance closed)
        tomTomNavigation.close()
    }

    ////// TEMPORARILY OVERRIDDEN GuidanceUpdatedListener to fix TTS bug //////
    val tts = AndroidTextToSpeechEngine(context, language = Locale.getDefault())
    private val playbackListener = object : MessagePlaybackListener {
        override fun onDone() {}
        override fun onError(error: TextToSpeechEngineError) { println(error) }
        override fun onStart() {}
        override fun onStop() {}
    }
    val guidanceUpdatedListener = object : GuidanceUpdatedListener {
        override fun onAnnouncementGenerated(announcement: GuidanceAnnouncement, shouldPlay: Boolean) {
            println("Announcement generated ${announcement.plainTextMessage} ($shouldPlay)")

            if (shouldPlay && announcement.plainTextMessage.isNotEmpty()) {
                val audioMessage = AudioMessage(
                    message = "Hello from guidance", // announcement.plainTextMessage,
                    messageType = MessageType.Plain,
                )
                println("Playing message...")
                tts.playAudioMessage(
                    audioMessage = audioMessage,
                    playbackListener = playbackListener
                )
            }
        }
        override fun onDistanceToNextInstructionChanged(
            distance: Distance,
            instructions: List<GuidanceInstruction>,
            currentPhase: InstructionPhase
        ) {
            //Your code here
        }
        override fun onInstructionsChanged(instructions: List<GuidanceInstruction>) {
            //Your code here
        }
    }


    /**
     * Initializes the Navigation view.
     * TODO this may be split up and/or commented further to improve legibility
     */
    init {
        log("Init navigation view with id $id")

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
                safetyLocationsConfiguration = SafetyLocationsConfiguration(apiKey)
            )
        )

        // Add the map container
        mapFragment = MapFragment.newInstance(mapOptions)
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
                if (closing) return@post
                navigationFragment.setTomTomNavigation(tomTomNavigation)
                navigationFragment.navigationView.hideSpeedView()
                // Set a TTS engine instead of just changing the language, which would work
                // but the TTS may not be available yet causing it to not-change at all
//                navigationFragment.changeTextToSpeechEngine(
//                    AndroidTextToSpeechEngine(context, Locale.getDefault())
//                )
                navigationFragment.addNavigationListener(navigationListener)
                // Add a custom guidance updated listener to ensure correct pronunciation
                tomTomNavigation.addGuidanceUpdatedListener(guidanceUpdatedListener)
                tomTomNavigation.addProgressUpdatedListener { progress ->
                    progressUpdatedPublisher.publish(
                        progress
                    )
                }
                tomTomNavigation.addDestinationArrivalListener { route ->
                    destinationArrivalPublisher.publish(route)
                }
                defaultCurrentLocationButtonMargin =
                    mapFragment.currentLocationButton.margin
                mapFragment.currentLocationButton.addCurrentLocationButtonClickListener {
                    recenterCamera()
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
                     safetyLocationStyle = SafetyLocationStyle(),
                ),
            )

            it.addMapPanningListener(object : MapPanningListener {
                override fun onMapPanningEnded() {}

                override fun onMapPanningOngoing() {}

                override fun onMapPanningStarted() {
                    if (tomTomMap?.cameraTrackingMode == CameraTrackingMode.FollowRouteDirection) {
                        // Release the camera
                        unlockCamera()
                    }
                }
            })

            // Set the map to the vehicle restrictions mode (for now, of the default vehicle)
            it.loadStyle(
                StandardStyles.VEHICLE_RESTRICTIONS,
                object : StyleLoadingCallback {
                    override fun onFailure(failure: LoadingStyleFailure) {
                        log("Failed to load vehicle restrictions!")
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
                log("No location permissions! We can't really do anything now :(")
            }
        }
    }

    /**
     * Called when the user pans the camera during navigation.
     * It unlocks the camera and hides the speed view.
     */
    private fun unlockCamera() {
        tomTomMap?.cameraTrackingMode = CameraTrackingMode.None
        navigationFragment.navigationView.hideSpeedView()
    }

    /**
     * Called when the current location button is tapped.
     * During navigation, this locks the camera onto the route again,
     * and by default it just re-centers the camera.
     */
    private fun recenterCamera() {
        if (tomTomNavigation.navigationSnapshot != null) {
            tomTomMap?.cameraTrackingMode =
                CameraTrackingMode.FollowRouteDirection
            navigationFragment.navigationView.showSpeedView()
        }
        // By default, the standard recenter is performed
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
     * Listen to the status of the navigation listener.
     * When started, the camera is set to follow the route, the location marker is changed to a chevron and the bottom padding is applied.
     * When stopped, these changes are reverted once again.
     */
    private val navigationListener =
        object : NavigationFragment.NavigationListener {
            override fun onStarted() {
                log("navigation started")
                navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.RUNNING)
                tomTomMap?.cameraTrackingMode =
                    CameraTrackingMode.FollowRouteDirection
                tomTomMap?.enableLocationMarker(
                    LocationMarkerOptions(
                        LocationMarkerOptions.Type.Chevron
                    )
                )
                val padding = Padding(0, 0, 0, (263 * density).toInt())
                tomTomMap?.setPadding(padding)
            }

            override fun onStopped() {
                navigationStatusPublisher.publish(NavigationStatusPublisher.NavigationStatus.STOPPED)
                log("navigation stopped!")
                stopNavigation()
            }
        }

    /**
     * Set the location provider back to the native one.
     */
    private fun closeAndDisposeNavLocationProvider() {
        if (navLocationProvider != null) {
            // Set back to native
            tomTomNavigation.locationProvider = locationProvider
            tomTomMap?.setLocationProvider(locationProvider)

            // Close and dispose the navigation one
            navLocationProvider?.disable()
            navLocationProvider?.close()
            navLocationProvider = null
        }
    }

    /**
     * Handle different method calls from Flutter to the native view.
     */
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        log("Called method ${call.method}...")

        when (call.method) {
            "planRoute" -> {
                val userLocation =
                    tomTomMap?.currentLocation?.position ?: return
                val routePlanningOptions =
                    RoutePlanningOptionsDeserializer.deserialize(
                        call.arguments as String,
                        userLocation
                    )

                planRoute(routePlanningOptions)
            }

            "startNavigation" -> {
                val useSimulation =
                    call.argument<Boolean>("useSimulation")!!
                startNavigation(useSimulation)
            }

            "stopNavigation" -> {
                stopNavigation()
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * Plan a route with the provided itinerary and link the vehicle.
     * If 0,0 was passed as an origin, we use the plan from the current location instead
     */
    private fun planRoute(routePlanningOptions: RoutePlanningOptions) {
        // Must not forget to:
        // A. Set the vehicle in TomTomNavigation to this vehicle (for re-planning!)
        // B. Show the correct restrictions for this vehicle (for visualization)

        this.routePlanningOptions = routePlanningOptions

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
                    routes = result.routes

                    if (routes.isNullOrEmpty()) {
                        log("Planned routes are empty!!!")
                        return
                    }

                    navigationVisualization?.displayRoutePlan(
                        RoutePlan(result.routes)
                    )

                    /// If multiple routes were planned attach listener for the user to select routes
                    if (result.routes.size > 1) {
                        navigationVisualization?.addRouteClickedListener(routeClickedListener)
                    }

                    setRoutePlan(routes!!.first())

                    tomTomMap?.zoomToRoutes(100)
                }

                override fun onFailure(failure: RoutingFailure) {
                    Toast.makeText(
                        context,
                        failure.message,
                        Toast.LENGTH_SHORT
                    ).show()

                    log("Could not plan routes: ${failure.message}")
                }

                override fun onRoutePlanned(route: Route) = Unit
            }
        )
    }

    /**
     * Start the navigation process using NavigationFragment.
     * This also sets the simulated location provider if requested,
     * shows the speed view and offsets the current location button
     */
    private fun startNavigation(useSimulation: Boolean) {
        // If we want to use simulation, set the location provider
        // to simulation location provider, otherwise use a map matched provider
        navLocationProvider =
            if (routePlan != null && useSimulation) SimulationLocationProvider.create(
                InterpolationStrategy(routePlan!!.route.geometry.map {
                    GeoLocation(it)
                })
            ) else MapMatchedLocationProvider(tomTomNavigation)

        if (navLocationProvider is SimulationLocationProvider) {
            tomTomNavigation.locationProvider = navLocationProvider!!
        }

        tomTomMap?.setLocationProvider(navLocationProvider)
        navLocationProvider?.enable()

        navigationFragment.navigationView.showSpeedView()
        if (mapFragment.currentLocationButton.margin == defaultCurrentLocationButtonMargin) {
            val margin =
                mapFragment.currentLocationButton.margin.copy(bottom = (density * (263 + 32)).toInt())
            mapFragment.currentLocationButton.margin = margin
        }

        tomTomMap?.loadStyle(
            StandardStyles.DRIVING,
            object : StyleLoadingCallback {
                override fun onFailure(failure: LoadingStyleFailure) {
                    log("Failed to load driving map style :(")
                }

                override fun onSuccess() {
                    if (routePlan != null) {
                        navigationFragment.startNavigation(routePlan!!)
                    } else {
                        log("Route plan is missing can't start navigation!!!")
                    }
                }
            }
        )
    }

    private fun setRoutePlan(route: Route) {
        if (routePlanningOptions == null ) {
            log("Can't set route plan without routePlanningOptions")
        }
        //TODO: rework this to publish route selected event.
        routePlannedPublisher.publish(route.summary)
        routePlan = com.tomtom.sdk.navigation.RoutePlan(
            route,
            routePlanningOptions!!
        )
    }

    /**
     * Stop the navigation process using NavigationFragment.
     * This also removes the simulated location provider if present
     * And resets the UI elements like the current location button and current speed view
     */
    private fun stopNavigation() {
        tomTomMap?.setPadding(Padding(0, 0, 0, 0))
        navigationFragment.stopNavigation()
        navigationVisualization?.clearRoutePlan()
        tomTomMap?.cameraTrackingMode = CameraTrackingMode.None
        tomTomMap?.enableLocationMarker(
            LocationMarkerOptions(
                LocationMarkerOptions.Type.Pointer
            )
        )

        // Set the location provider back to the native one
        closeAndDisposeNavLocationProvider()

        navigationFragment.navigationView.hideSpeedView()
        tomTomMap?.loadStyle(
            StandardStyles.VEHICLE_RESTRICTIONS,
            object : StyleLoadingCallback {
                override fun onFailure(failure: LoadingStyleFailure) {
                    log("Failed to load vehicle restrictions!")
                }

                override fun onSuccess() {
                    navigationStatusPublisher.publish(
                        NavigationStatusPublisher.NavigationStatus.READY
                    )
                    tomTomMap?.hideVehicleRestrictions()
                }

            })
        mapFragment.currentLocationButton.margin =
            defaultCurrentLocationButtonMargin!!
    }

    private val routeClickedListener = { route: Route, _: com.tomtom.sdk.map.display.route.Route ->
        navigationVisualization?.selectRoute(route.id)

        val selectedRoute =  routes!!.find { it.id == route.id }

        if (selectedRoute != null ) {
            setRoutePlan(selectedRoute)
        } else {
            log("Selected routeID is not found in the planned routes")
        }
    }
}


private fun log(msg: String) {
    println("[TomTomNavigation]: $msg")
}
