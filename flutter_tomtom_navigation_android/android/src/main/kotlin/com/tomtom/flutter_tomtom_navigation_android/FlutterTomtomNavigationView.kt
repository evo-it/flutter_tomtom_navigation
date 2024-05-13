package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import android.content.ContextWrapper
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.View
import android.view.View.OnAttachStateChangeListener
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.doOnAttach
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import com.tomtom.sdk.map.display.ui.MapFragment
import com.tomtom.sdk.navigation.ui.NavigationFragment
import com.tomtom.sdk.navigation.ui.NavigationUiOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import java.lang.IllegalArgumentException
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
    private var channel: MethodChannel
//    private val publish: (String) -> (Unit)

    private val view = ConstraintLayout(context)

    // SDK objects
    private val mapFragment: MapFragment
    private val navigationFragment: NavigationFragment

    override fun getView(): View {
        return view
    }

//    private lateinit var tomTomMap: TomTomMap
//    // TomTom SDK objects, which should be disposed by calling close()!
//    private lateinit var locationProvider: LocationProvider
//    private lateinit var routePlanner: RoutePlanner
//    private lateinit var tomTomNavigation: TomTomNavigation
//    private lateinit var navigationTileStore: NavigationTileStore
//    private var navigationVisualization: NavigationVisualization? = null
//    private lateinit var route: Route
//
//    // Other SDK objects that do not have their own lifecycle
//    private var mapFragment: MapFragment
//    private var navigationFragment: NavigationFragment
//
//    private lateinit var onLocationUpdateListener: OnLocationUpdateListener
//
//    // private var route: Route? = null
//    private lateinit var routePlanningOptions: RoutePlanningOptions
//    private var useSimulation: Boolean = true

    override fun dispose() {
//        locationProvider.removeOnLocationUpdateListener(onLocationUpdateListener)

        channel.setMethodCallHandler(null)

//        navigationVisualization?.close()
//        tomTomNavigation.close()
//        navigationTileStore.close()
//        routePlanner.close()
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

        // Initialize the TomTomMap
        mapFragment = MapFragment.newInstance(mapOptions)
        navigationFragment = NavigationFragment.newInstance(NavigationUiOptions())

        // Add the map container
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
        val navigationView = FragmentContainerView(context)
        navigationView.id = Random.nextInt()
        view.addView(navigationView)
        navigationView.doOnAttach {
            // When it is first attached, add the actual navigation fragment
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, navigationFragment)?.commit()
            // TODO one frame is drawn with the speed view shown. Can we hide that somehow?
            Handler(Looper.getMainLooper()).post { navigationFragment.navigationView.hideSpeedView() }
        }

//        @Suppress("UNCHECKED_CAST")
//        publish = creationParams["publish"] as (String) -> (Unit)
//
//        sendNavigationStatusUpdate(NavigationStatus.INITIALIZING)
//
//        initNavigationTileStore()
//        initLocationProvider()
//        initRouting()
//
//        // The root view is a RelativeLayout
//        relativeLayout = RelativeLayout(context)
//
//        // This layout contains two views: the map view...
//        mapFragment = MapFragment.newInstance(mapOptions)
//        mapFragmentContainer = FragmentContainerView(context)
//        mapFragmentContainer.id = Random.nextInt()
//        mapFragmentContainer.doOnAttach {
//            val activity = it.context.getFragmentActivityOrThrow()
//            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
//                ?.replace(it.id, mapFragment)?.commit()
//            sendNavigationStatusUpdate(NavigationStatus.MAP_LOADED)
//
//            mapFragment.getMapAsync { map ->
//                tomTomMap = map
//                enableUserLocation()
//
//                tomTomMap.loadStyle(
//                    StandardStyles.VEHICLE_RESTRICTIONS,
//                    styleLoadingCallback,
//                )
//                sendNavigationStatusUpdate(NavigationStatus.RESTRICTIONS_LOADED)
//            }
//        }
//        relativeLayout.addView(mapFragmentContainer)
//
//        // ...and the navigation view
//        navigationFragment = NavigationFragment.newInstance(
//            NavigationUiOptions()
//        )
//
//        navigationFragmentContainer = FragmentContainerView(context)
//        navigationFragmentContainer.id = Random.nextInt()
//        navigationFragmentContainer.foregroundGravity = Gravity.BOTTOM
//        val params = RelativeLayout.LayoutParams(
//            LayoutParams.MATCH_PARENT,
//            LayoutParams.MATCH_PARENT
//        )
//        navigationFragmentContainer.layoutParams = params
//
//        // Hide it by default
//        navigationFragmentContainer.visibility = View.INVISIBLE
//        navigationFragmentContainer.doOnAttach {
//            val activity = it.context.getFragmentActivityOrThrow()
//            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
//                ?.replace(it.id, navigationFragment)?.commit()
//        }
//        relativeLayout.addView(navigationFragmentContainer)
    }

//    private fun initNavigationVisualization() {
//        navigationVisualization = NavigationVisualizationFactory.create(
//            tomTomMap, tomTomNavigation, StyleConfiguration(
//                routeTrafficIncident = RouteTrafficIncidentStyle(),
////                safetyLocationStyle = SafetyLocationStyle(),
//            ), navigationTileStore
//        )
////        navigationVisualization.safetyLocationVisualization.setSafetyLocationsCountOption(SafetyLocationCountOptions.NumberOfLocations(5))
//    }

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

//    private fun showNavigation() {
//        navigationFragmentContainer.visibility = View.VISIBLE
//    }
//
//    private fun hideNavigation() {
//        navigationFragmentContainer.visibility = View.INVISIBLE
//    }

//    /**
//     * The SDK provides a [NavigationTileStore] class that is used between different modules to get tile data based
//     * on the online map.
//     */
//    private fun initNavigationTileStore() {
//        navigationTileStore = NavigationTileStore.create(
//            context = context,
//            navigationTileStoreConfig = NavigationTileStoreConfiguration(
//                apiKey = apiKey
//            )
//        )
//    }

    // Below functions are copied from/based on the example activity
    // https://github.com/tomtom-international/tomtom-navigation-android-examples/blob/main/app/src/main/java/com/tomtom/sdk/examples/usecase/BasicNavigationActivity.kt

//    /**
//     * The SDK provides a LocationProvider interface that is used between different modules to get location updates.
//     * This examples uses the AndroidLocationProvider.
//     * Under the hood, the engine uses Android’s system location services.
//     */
//    private fun initLocationProvider() {
//        locationProvider = AndroidLocationProvider(context = context)
//    }
//
//    /**
//     * You can plan route by initializing by using the online route planner and default route replanner.
//     */
//    private fun initRouting() {
//        routePlanner =
//            OnlineRoutePlanner.create(context = context, apiKey = apiKey)
//    }
//
//    /**
//     * To use navigation in the application, start by by initialising the navigation configuration.
//     */
//    private fun initNavigation() {
//        val configuration = Configuration(
//            context = context,
//            locationProvider = locationProvider,
//            routePlanner = routePlanner,
//            vehicleProvider = VehicleProviderFactory.create(vehicle = routePlanningOptions.vehicle),
//            navigationTileStore = navigationTileStore,
//        )
//        tomTomNavigation = OnlineTomTomNavigationFactory.create(configuration)
//        initNavigationVisualization()
//    }
//
//    /**
//     * In order to show the user’s location, the application must use the device’s location services, which requires the appropriate permissions.
//     */
//    private fun enableUserLocation() {
//        if (areLocationPermissionsGranted()) {
//            showUserLocation()
//        } else {
//            println("No location permissions :(")
//        }
//    }
//
//    /**
//     * The LocationProvider itself only reports location changes. It does not interact internally with the map or navigation.
//     * Therefore, to show the user’s location on the map you have to set the LocationProvider to the TomTomMap.
//     * You also have to manually enable the location indicator.
//     * It can be configured using the LocationMarkerOptions class.
//     *
//     * Read more about user location on the map in the Showing User Location guide.
//     */
//    private fun showUserLocation() {
//        locationProvider.enable()
//        // zoom to current location at city level
//        onLocationUpdateListener = OnLocationUpdateListener { location ->
//            val result = Gson().toJson(location)
//
//            val response = appendNavigationUpdateStatusToJson(
//                result,
//                NativeEventType.LOCATION_UPDATE,
//            )
//            publish(response)
//        }
//        locationProvider.addOnLocationUpdateListener(onLocationUpdateListener)
//        tomTomMap.setLocationProvider(locationProvider)
//        val locationMarker =
//            LocationMarkerOptions(type = LocationMarkerOptions.Type.Pointer)
//        tomTomMap.enableLocationMarker(locationMarker)
//    }
//
//    /**
//     * Checks whether navigation is currently running.
//     */
//    private fun isNavigationRunning(): Boolean =
//        tomTomNavigation.navigationSnapshot != null
//
//    /**
//     * The RoutePlanningCallback itself has two methods.
//     * - The first method is triggered if the request fails.
//     * - The second method returns RoutePlanningResponse containing the routing results.
//     * - This example draws the first retrieved route on the map, using the RouteOptions class.
//     */
//    private val routePlanningCallback = object : RoutePlanningCallback {
//        override fun onSuccess(result: RoutePlanningResponse) {
//            val summaryJson = Gson().toJson(result.routes.first().summary)
//            val json =
//                appendNavigationUpdateStatusToJson(
//                    summaryJson,
//                    NativeEventType.ROUTE_PLANNED
//                )
//            publish(json)
//
//            initNavigation()
//            navigationVisualization?.displayRoutePlan(RoutePlan(result.routes))
//            route = result.routes.first()
//            navigationVisualization?.selectRoute(route.id)
//            tomTomMap.zoomToRoutes(ZOOM_TO_ROUTE_PADDING)
//        }
//
//        override fun onFailure(failure: RoutingFailure) {
//            Toast.makeText(context, failure.message, Toast.LENGTH_SHORT).show()
//        }
//
//        override fun onRoutePlanned(route: Route) = Unit
//    }

//    /**
//     * Used to start navigation by
//     * - initializing the NavigationFragment to display the UI navigation information,
//     * - passing the Route object along which the navigation will be done, and RoutePlanningOptions used during the route planning,
//     * - handling the updates to the navigation states using the NavigationListener.
//     * Note that you have to set the previously-created TomTom Navigation object to the NavigationFragment before using it.
//     */
//
//    private fun startNavigation() {
//        showNavigation()
//        navigationFragment.setTomTomNavigation(tomTomNavigation)
//        val routePlan = NavigationRoutePlan(route, routePlanningOptions)
//        navigationFragment.changeAudioLanguage(Locale.getDefault())
//        navigationFragment.startNavigation(routePlan)
//        navigationFragment.addNavigationListener(navigationListener)
//        tomTomNavigation.addProgressUpdatedListener(progressUpdatedListener)
//        tomTomNavigation.addDestinationArrivalListener(
//            destinationArrivalListener
//        )
//    }

//    /**
//     * Handle the updates to the navigation states using the NavigationListener
//     * - Use CameraChangeListener to observe camera tracking mode and detect if the camera is locked on the chevron. If the user starts to move the camera, it will change and you can adjust the UI to suit.
//     * - Use the SimulationLocationProvider for testing purposes.
//     * - Once navigation is started, the camera is set to follow the user position, and the location indicator is changed to a chevron. To match raw location updates to the routes, use MapMatchedLocationProvider and set it to the TomTomMap.
//     * - Set the bottom padding on the map. The padding sets a safe area of the MapView in which user interaction is not received. It is used to uncover the chevron in the navigation panel.
//     */
//    private val navigationListener =
//        object : NavigationFragment.NavigationListener {
//            override fun onStarted() {
//                println("navigation started")
//                sendNavigationStatusUpdate(NavigationStatus.RUNNING)
//
//                tomTomMap.addCameraChangeListener(cameraChangeListener)
//                tomTomMap.cameraTrackingMode =
//                    CameraTrackingMode.FollowRouteDirection
//                tomTomMap.enableLocationMarker(
//                    LocationMarkerOptions(
//                        LocationMarkerOptions.Type.Chevron
//                    )
//                )
//                navigationFragment.navigationView.setCurrentSpeedClickListener(
//                    setCurrentSpeedClickListener
//                )
//                tomTomMap.addRouteClickListener(routeClickListener)
//
//                setMapMatchedLocationProvider()
//                setLocationProviderToNavigation()
//                setMapNavigationPadding()
//            }
//
//            override fun onStopped() {
//                sendNavigationStatusUpdate(NavigationStatus.STOPPED)
//                println("stopped!")
//                stopNavigation()
//            }
//        }
//
//    private val setCurrentSpeedClickListener = View.OnClickListener {
//        toggleOverviewCamera()
//    }
//
//    private val routeClickListener = RouteClickListener {
//        toggleOverviewCamera()
//    }

//    private fun toggleOverviewCamera() {
//        val currentMode = tomTomMap.cameraTrackingMode
//        if (currentMode == CameraTrackingMode.RouteOverview || currentMode == CameraTrackingMode.None) {
//            tomTomMap.cameraTrackingMode =
//                CameraTrackingMode.FollowRouteDirection
//        } else {
//            tomTomMap.cameraTrackingMode = CameraTrackingMode.RouteOverview
//        }
//    }
//
//    private val progressUpdatedListener = ProgressUpdatedListener {
//        sendRouteUpdateEvent(it)
//    }

//    private val destinationArrivalListener = DestinationArrivalListener {
//        // Send event
//        val route = "{\"routeId\": \"${it.id}\"}"
//        val json = appendNavigationUpdateStatusToJson(
//            route,
//            NativeEventType.DESTINATION_ARRIVAL
//        )
//        publish(json)
//        navigationVisualization?.clearRoutePlan()
//    }

//    /**
//     * Use the SimulationLocationProvider for testing purposes.
//     */
//    private fun setLocationProviderToNavigation() {
//        locationProvider = if (useSimulation) {
//            val route = navigationVisualization!!.selectedRoute!!
//            val routeGeoLocations = route.geometry.map { GeoLocation(it) }
//            val simulationStrategy = InterpolationStrategy(routeGeoLocations)
//            SimulationLocationProvider.create(strategy = simulationStrategy)
//        } else {
//            AndroidLocationProvider(context)
//        }
//        tomTomNavigation.locationProvider = locationProvider
//        locationProvider.enable()
//    }

//    /**
//     * Stop the navigation process using NavigationFragment.
//     * This hides the UI elements and calls the TomTomNavigation.stop() method.
//     * Don’t forget to reset any map settings that were changed, such as camera tracking, location marker, and map padding.
//     */
//    private fun stopNavigation() {
//        tomTomMap.removeRouteClickListener(routeClickListener)
//        navigationFragment.stopNavigation()
//        navigationVisualization?.clearRoutePlan()
//        mapFragment.currentLocationButton.visibilityPolicy =
//            CurrentLocationButton.VisibilityPolicy.InvisibleWhenRecentered
//        tomTomMap.removeCameraChangeListener(cameraChangeListener)
//        tomTomMap.cameraTrackingMode = CameraTrackingMode.None
//        tomTomMap.enableLocationMarker(
//            LocationMarkerOptions(
//                LocationMarkerOptions.Type.Pointer
//            )
//        )
//        resetMapPadding()
//        navigationFragment.removeNavigationListener(navigationListener)
//        tomTomNavigation.removeProgressUpdatedListener(progressUpdatedListener)
//        tomTomNavigation.removeDestinationArrivalListener(
//            destinationArrivalListener
//        )
//        hideNavigation()
//        initLocationProvider()
//        enableUserLocation()
//    }
//
//    private val styleLoadingCallback = object : StyleLoadingCallback {
//        override fun onSuccess() {
//            tomTomMap.hideVehicleRestrictions()
//            sendNavigationStatusUpdate(NavigationStatus.READY)
//        }
//
//        override fun onFailure(failure: LoadingStyleFailure) {}
//    }
//
//    private val styleLoadingCallback2 = object : StyleLoadingCallback {
//        override fun onSuccess() {
//            startNavigation()
//        }
//
//        override fun onFailure(failure: LoadingStyleFailure) {}
//    }

    /**
     * Set the bottom padding on the map. The padding sets a safe area of the MapView in which user interaction is not received. It is used to uncover the chevron in the navigation panel.
     */
//    private fun setMapNavigationPadding() {
//        val paddingBottom =
//            240 // resources.getDimensionPixelOffset(R.dimen.map_padding_bottom)
//        val padding = Padding(0, 0, 0, paddingBottom)
//        setPadding(padding)
//    }

//    private fun setPadding(padding: Padding) {
//        val scale: Float =
//            context.getFragmentActivityOrThrow().resources.displayMetrics.density
//
//        val paddingInPixels = Padding(
//            top = (padding.top * scale).toInt(),
//            left = (padding.left * scale).toInt(),
//            right = (padding.right * scale).toInt(),
//            bottom = (padding.bottom * scale).toInt()
//        )
//        println("setting padding (in pixels) to $paddingInPixels, from $padding")
//        tomTomMap.setPadding(paddingInPixels)
//    }

//    private fun resetMapPadding() {
//        tomTomMap.setPadding(Padding(0, 0, 0, 0))
//    }

    /**
     * Once navigation is started, the camera is set to follow the user position, and the location indicator is changed to a chevron.
     * To match raw location updates to the routes, use MapMatchedLocationProvider and set it to the TomTomMap.
     */
//    private fun setMapMatchedLocationProvider() {
//        val mapMatchedLocationProvider =
//            MapMatchedLocationProvider(tomTomNavigation)
//        tomTomMap.setLocationProvider(mapMatchedLocationProvider)
//        mapMatchedLocationProvider.enable()
//    }

    /**
     *
     * The method removes all polygons, circles, routes, and markers that were previously added to the map.
     */
//    private fun clearMap() {
//        tomTomMap.clear()
//        tomTomMap.hideVehicleRestrictions()
//    }

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

//    private fun areLocationPermissionsGranted() =
//        ContextCompat.checkSelfPermission(
//            context,
//            Manifest.permission.ACCESS_FINE_LOCATION
//        ) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(
//            context,
//            Manifest.permission.ACCESS_COARSE_LOCATION
//        ) == PackageManager.PERMISSION_GRANTED

//    companion object {
//        private const val ZOOM_TO_ROUTE_PADDING = 100
//    }

    /**
     * Handle different method calls from Flutter to the navigation view.
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("Called method ${call.method}...")

//        when (call.method) {
//            "planRoute" -> {
//                val userLocation =
//                    tomTomMap.currentLocation?.position ?: return
//                routePlanningOptions =
//                    RoutePlanningOptionsDeserializer.deserialize(
//                        call.arguments as String,
//                        userLocation
//                    )
//                clearMap()
//
//                // Show the vehicle restrictions that apply for the current vehicle
//                // TODO do we want to make this optional? Is this what "showLayer" can be used for?
//                tomTomMap.showVehicleRestrictions(routePlanningOptions.vehicle)
//                routePlanner.planRoute(
//                    routePlanningOptions,
//                    routePlanningCallback
//                )
//            }
//
//            "startNavigation" -> {
//                val useSimulation = call.argument<Boolean>("useSimulation")!!
//
//                // Same thing that is attached to the RouteClickListener in the example
//                if (!isNavigationRunning()) {
//                    mapFragment.currentLocationButton.visibilityPolicy =
//                        CurrentLocationButton.VisibilityPolicy.Invisible
//                    tomTomMap.loadStyle(
//                        StandardStyles.DRIVING,
//                        styleLoadingCallback2
//                    )
//                    this.useSimulation = useSimulation
//                }
//            }
//
//            "stopNavigation" -> {
//                stopNavigation()
//            }
//
//            else -> {
//                result.notImplemented()
//            }
//        }
    }
//
//    private fun sendNavigationStatusUpdate(status: NavigationStatus) {
//        val jsonString = "{" +
//                "  \"navigationStatus\": ${status.value}" +
//                "}"
//
//        val response =
//            appendNavigationUpdateStatusToJson(
//                jsonString,
//                NativeEventType.NAVIGATION_UPDATE
//            )
//
//        publish(response)
//    }
//
//    private fun sendRouteUpdateEvent(event: RouteProgress) {
//        val result = Gson().toJson(event)
//
//        val response = appendNavigationUpdateStatusToJson(
//            result,
//            NativeEventType.ROUTE_UPDATE
//        )
//        publish(response)
//    }
//
//    // Adds the navigation Status to any Json string
//    private fun appendNavigationUpdateStatusToJson(
//        json: String,
//        status: NativeEventType
//    ): String {
//        val newJsonObject = JsonObject()
//        newJsonObject.addProperty("nativeEventType", status.value)
//        newJsonObject.addProperty("data", json)
//
//        return newJsonObject.toString()
//    }
}

//// This should represent the communication between the native code and dart plugin
//enum class NativeEventType(val value: Int) {
//    ROUTE_UPDATE(1),
//    ROUTE_PLANNED(2),
//    NAVIGATION_UPDATE(3),
//    DESTINATION_ARRIVAL(4),
//    LOCATION_UPDATE(5),
//}
//
//enum class NavigationStatus(val value: Int) {
//    INITIALIZING(0),
//    MAP_LOADED(1),
//    RESTRICTIONS_LOADED(2),
//    READY(3),
//    RUNNING(4),
//    STOPPED(5),
//}