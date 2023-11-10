package com.tomtom.flutter_tomtom_navigation_android

import android.Manifest
import android.content.Context
import android.content.ContextWrapper
import android.content.pm.PackageManager
import android.view.Gravity
import android.view.View
import android.view.ViewGroup.LayoutParams
import android.widget.Button
import android.widget.RelativeLayout
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.core.view.doOnAttach
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainer
import androidx.fragment.app.FragmentContainerView
import com.tomtom.sdk.location.GeoLocation
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.LocationProvider
import com.tomtom.sdk.location.OnLocationUpdateListener
import com.tomtom.sdk.location.android.AndroidLocationProvider
import com.tomtom.sdk.location.mapmatched.MapMatchedLocationProvider
import com.tomtom.sdk.location.simulation.SimulationLocationProvider
import com.tomtom.sdk.location.simulation.strategy.InterpolationStrategy
import com.tomtom.sdk.map.display.MapOptions
import com.tomtom.sdk.map.display.TomTomMap
import com.tomtom.sdk.map.display.camera.CameraChangeListener
import com.tomtom.sdk.map.display.camera.CameraOptions
import com.tomtom.sdk.map.display.camera.CameraTrackingMode
import com.tomtom.sdk.map.display.common.screen.Padding
import com.tomtom.sdk.map.display.gesture.MapLongClickListener
import com.tomtom.sdk.map.display.location.LocationMarkerOptions
import com.tomtom.sdk.map.display.route.Instruction
import com.tomtom.sdk.map.display.route.RouteClickListener
import com.tomtom.sdk.map.display.route.RouteOptions
import com.tomtom.sdk.map.display.ui.MapFragment
import com.tomtom.sdk.map.display.ui.currentlocation.CurrentLocationButton
import com.tomtom.sdk.navigation.NavigationFailure
import com.tomtom.sdk.navigation.ProgressUpdatedListener
import com.tomtom.sdk.navigation.RoutePlan
import com.tomtom.sdk.navigation.RouteUpdateReason
import com.tomtom.sdk.navigation.RouteUpdatedListener
import com.tomtom.sdk.navigation.TomTomNavigation
import com.tomtom.sdk.navigation.online.Configuration
import com.tomtom.sdk.navigation.online.OnlineTomTomNavigationFactory
import com.tomtom.sdk.navigation.routereplanner.RouteReplanner
import com.tomtom.sdk.navigation.routereplanner.online.OnlineRouteReplannerFactory
import com.tomtom.sdk.navigation.ui.NavigationFragment
import com.tomtom.sdk.navigation.ui.NavigationUiOptions
import com.tomtom.sdk.routing.RoutePlanner
import com.tomtom.sdk.routing.RoutePlanningCallback
import com.tomtom.sdk.routing.RoutePlanningResponse
import com.tomtom.sdk.routing.RoutingFailure
import com.tomtom.sdk.routing.online.OnlineRoutePlanner
import com.tomtom.sdk.routing.options.Itinerary
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.guidance.AnnouncementPoints
import com.tomtom.sdk.routing.options.guidance.ExtendedSections
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.routing.options.guidance.InstructionPhoneticsType
import com.tomtom.sdk.routing.options.guidance.InstructionType
import com.tomtom.sdk.routing.options.guidance.ProgressPoints
import com.tomtom.sdk.routing.route.Route
import com.tomtom.sdk.vehicle.DefaultVehicleProvider
import com.tomtom.sdk.vehicle.Vehicle
import io.flutter.plugin.platform.PlatformView
import kotlin.random.Random

class FlutterTomtomNavigationView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?
) : PlatformView {
    private val context: Context
    private val apiKey: String

    // The relative layout contains the mapview (and navigation view),
    // stacked on top of each other.
    private val relativeLayout: RelativeLayout
    private val mapFragmentContainer: FragmentContainerView
    private val navigationFragmentContainer: FragmentContainerView

    override fun getView(): View {
        return relativeLayout
    }

    private lateinit var tomTomMap: TomTomMap

    // TomTom SDK objects, which should be disposed by calling close()!
    private lateinit var locationProvider: LocationProvider
    private lateinit var routePlanner: RoutePlanner

    private lateinit var routeReplanner: RouteReplanner
    private lateinit var tomTomNavigation: TomTomNavigation

    // Other SDK objects that do not have their own lifecycle
    private var mapFragment: MapFragment
    private lateinit var navigationFragment: NavigationFragment
    private lateinit var onLocationUpdateListener: OnLocationUpdateListener
    private var route: Route? = null
    private lateinit var routePlanningOptions: RoutePlanningOptions

    private var padding = 0

    override fun dispose() {
        tomTomMap.setLocationProvider(null)

        tomTomNavigation.close()
        routeReplanner.close()

        routePlanner.close()
        locationProvider.close()
    }

    init {
        this.context = context

        // Get the API key from the creation params
        apiKey = creationParams?.get("apiKey") as String

        // The root view is a RelativeLayout
        relativeLayout = RelativeLayout(context)

        // This layout contains two views: the map view...
        mapFragment = MapFragment.newInstance(MapOptions(mapKey = apiKey))
        mapFragmentContainer = FragmentContainerView(context)
        mapFragmentContainer.id = Random.nextInt()
        mapFragmentContainer.doOnAttach {
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, mapFragment)?.commit()
        }
        relativeLayout.addView(mapFragmentContainer)

        // ...and the navigation view
        navigationFragment = NavigationFragment.newInstance(
            NavigationUiOptions()
        )

        navigationFragmentContainer = FragmentContainerView(context)
        navigationFragmentContainer.id = Random.nextInt()
        navigationFragmentContainer.foregroundGravity = Gravity.BOTTOM
        val params = RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        navigationFragmentContainer.layoutParams = params

        // Hide it by default
        navigationFragmentContainer.visibility = View.INVISIBLE
        navigationFragmentContainer.doOnAttach {
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, navigationFragment)?.commit()
        }
        relativeLayout.addView(navigationFragmentContainer)

        // Button for testing purposes
        val button = Button(context)
        button.text = "Toggle navigation view"
        button.setOnClickListener {
//            if(navigationFragmentContainer.visibility == View.VISIBLE) {
//                hideNavigation()
//            } else {
//                showNavigation()
//            }
            if (padding == 0) {
                padding = 200
                tomTomMap.cameraTrackingMode = CameraTrackingMode.FollowRoute
                tomTomMap.enableLocationMarker(
                    LocationMarkerOptions(
                        LocationMarkerOptions.Type.Chevron)
                )
                setPadding(Padding(0, 0, 0, padding))
            } else {
                padding = 0
                tomTomMap.cameraTrackingMode = CameraTrackingMode.None
                tomTomMap.enableLocationMarker(
                    LocationMarkerOptions(
                        LocationMarkerOptions.Type.Pointer)
                )
                setPadding(Padding(0, 0, 0, padding))
            }
            setPadding(Padding(0, 0, 0, padding))
        }
        relativeLayout.addView(button)

        initLocationProvider()
        initRouting()
        initNavigation()

        mapFragment.getMapAsync {
            tomTomMap = it
            enableUserLocation()
            setUpMapListeners()
        }
    }

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

    private fun showNavigation() {
        navigationFragmentContainer.visibility = View.VISIBLE
    }

    private fun hideNavigation() {
        navigationFragmentContainer.visibility = View.INVISIBLE
    }

    // Below functions are copied from/based on the example activity
    // https://github.com/tomtom-international/tomtom-navigation-android-examples/blob/main/app/src/main/java/com/tomtom/sdk/examples/usecase/BasicNavigationActivity.kt

    /**
     * The SDK provides a LocationProvider interface that is used between different modules to get location updates.
     * This examples uses the AndroidLocationProvider.
     * Under the hood, the engine uses Android’s system location services.
     */
    private fun initLocationProvider() {
        locationProvider = AndroidLocationProvider(context = context)
    }

    /**
     * You can plan route by initializing by using the online route planner and default route replanner.
     */
    private fun initRouting() {
        routePlanner =
            OnlineRoutePlanner.create(context = context, apiKey = apiKey)
        routeReplanner = OnlineRouteReplannerFactory.create(routePlanner)
    }

    /**
     * To use navigation in the application, start by by initialising the navigation configuration.
     */
    private fun initNavigation() {
        val configuration = Configuration(
            context = context,
            apiKey = apiKey,
            locationProvider = locationProvider,
            routeReplanner = routeReplanner,
            vehicleProvider = DefaultVehicleProvider(vehicle = Vehicle.Car())
        )
        tomTomNavigation = OnlineTomTomNavigationFactory.create(configuration)
    }

    /**
     * In order to show the user’s location, the application must use the device’s location services, which requires the appropriate permissions.
     */
    private fun enableUserLocation() {
        if (areLocationPermissionsGranted()) {
            showUserLocation()
        } else {
            println("No location permissions :(")
        }
    }

    /**
     * The LocationProvider itself only reports location changes. It does not interact internally with the map or navigation.
     * Therefore, to show the user’s location on the map you have to set the LocationProvider to the TomTomMap.
     * You also have to manually enable the location indicator.
     * It can be configured using the LocationMarkerOptions class.
     *
     * Read more about user location on the map in the Showing User Location guide.
     */
    private fun showUserLocation() {
        locationProvider.enable()
        // zoom to current location at city level
        onLocationUpdateListener = OnLocationUpdateListener { location ->
            tomTomMap.moveCamera(CameraOptions(location.position, zoom = 8.0))
            locationProvider.removeOnLocationUpdateListener(onLocationUpdateListener)
        }
        locationProvider.addOnLocationUpdateListener(onLocationUpdateListener)
        tomTomMap.setLocationProvider(locationProvider)
        val locationMarker = LocationMarkerOptions(type = LocationMarkerOptions.Type.Pointer)
        tomTomMap.enableLocationMarker(locationMarker)
    }

    /**
     * In this example on planning a route, the origin is the user’s location and the destination is determined by the user selecting a location on the map.
     * Navigation is started once the user taps on the route.
     *
     * To mark the destination on the map, add the MapLongClickListener event handler to the map view.
     * To start navigation, add the addRouteClickListener event handler to the map view.
     */
    private fun setUpMapListeners() {
        tomTomMap.addMapLongClickListener(mapLongClickListener)
        tomTomMap.addRouteClickListener(routeClickListener)
    }

    /**
     * Used to calculate a route based on a selected location.
     * - The method removes all polygons, circles, routes, and markers that were previously added to the map.
     * - It then creates a route between the user’s location and the selected location.
     * - The method needs to return a boolean value when the callback is consumed.
     */
    private val mapLongClickListener = MapLongClickListener { geoPoint ->
        clearMap()
        calculateRouteTo(geoPoint)
        true
    }

    /**
     * Checks whether navigation is currently running.
     */
    private fun isNavigationRunning(): Boolean = tomTomNavigation.navigationSnapshot != null


    /**
     * Used to start navigation based on a tapped route, if navigation is not already running.
     * - Hide the location button
     * - Then start the navigation using the selected route.
     */
    private val routeClickListener = RouteClickListener {
        if (!isNavigationRunning()) {
            route?.let { route ->
                mapFragment.currentLocationButton.visibilityPolicy = CurrentLocationButton.VisibilityPolicy.Invisible
                startNavigation(route)
            }
        }
    }

    /**
     * Used to calculate a route using the following parameters:
     * - InstructionType - This indicates that the routing result has to contain guidance instructions.
     * - InstructionPhoneticsType - This specifies whether to include phonetic transcriptions in the response.
     * - AnnouncementPoints - When this parameter is specified, the instruction in the response includes up to three additional fine-grained announcement points, each with its own location, maneuver type, and distance to the instruction point.
     * - ExtendedSections - This specifies whether to include extended guidance sections in the response, such as sections of type road shield, lane, and speed limit.
     * - ProgressPoints - This specifies whether to include progress points in the response.
     */
    private fun calculateRouteTo(destination: GeoPoint) {
        val userLocation =
            tomTomMap.currentLocation?.position ?: return
        val itinerary = Itinerary(origin = userLocation, destination = destination)
        routePlanningOptions = RoutePlanningOptions(
            itinerary = itinerary,
            guidanceOptions = GuidanceOptions(
                instructionType = InstructionType.Text,
                phoneticsType = InstructionPhoneticsType.Ipa,
                announcementPoints = AnnouncementPoints.All,
                extendedSections = ExtendedSections.All,
                progressPoints = ProgressPoints.All
            ),
            vehicle = Vehicle.Car()
        )
        routePlanner.planRoute(routePlanningOptions, routePlanningCallback)
    }

    /**
     * The RoutePlanningCallback itself has two methods.
     * - The first method is triggered if the request fails.
     * - The second method returns RoutePlanningResponse containing the routing results.
     * - This example draws the first retrieved route on the map, using the RouteOptions class.
     */
    private val routePlanningCallback = object : RoutePlanningCallback {
        override fun onSuccess(result: RoutePlanningResponse) {
            route = result.routes.first()
            drawRoute(route!!)
            tomTomMap.zoomToRoutes(ZOOM_TO_ROUTE_PADDING)
        }

        override fun onFailure(failure: RoutingFailure) {
            Toast.makeText(context, failure.message, Toast.LENGTH_SHORT).show()
        }

        override fun onRoutePlanned(route: Route) = Unit
    }

    /**
     * Used to draw route on the map
     * You can show the overview of the added routes using the TomTomMap.zoomToRoutes(Int) method. Note that its padding parameter is expressed in pixels.
     */
    private fun drawRoute(route: Route) {
        val instructions = route.mapInstructions()
        val routeOptions = RouteOptions(
            geometry = route.geometry,
            destinationMarkerVisible = true,
            departureMarkerVisible = true,
            instructions = instructions,
            routeOffset = route.routePoints.map { it.routeOffset }
        )
        tomTomMap.addRoute(routeOptions)
    }

    /**
     * For the navigation use case, the instructions can be drawn on the route in form of arrows that indicate maneuvers.
     * To do this, map the Instruction object provided by routing to the Instruction object used by the map.
     * Note that during navigation, you need to update the progress property of the drawn route to display the next instructions.
     */
    private fun Route.mapInstructions(): List<Instruction> {
        val routeInstructions = legs.flatMap { routeLeg -> routeLeg.instructions }
        return routeInstructions.map {
            Instruction(
                routeOffset = it.routeOffset,
                combineWithNext = it.combineWithNext
            )
        }
    }

    /**
     * Used to start navigation by
     * - initializing the NavigationFragment to display the UI navigation information,
     * - passing the Route object along which the navigation will be done, and RoutePlanningOptions used during the route planning,
     * - handling the updates to the navigation states using the NavigationListener.
     * Note that you have to set the previously-created TomTom Navigation object to the NavigationFragment before using it.
     */

    private fun startNavigation(route: Route) {
        showNavigation()
        navigationFragment.setTomTomNavigation(tomTomNavigation)
        val routePlan = RoutePlan(route, routePlanningOptions)
        navigationFragment.startNavigation(routePlan)
        navigationFragment.addNavigationListener(navigationListener)
        tomTomNavigation.addProgressUpdatedListener(progressUpdatedListener)
        tomTomNavigation.addRouteUpdatedListener(routeUpdatedListener)
    }

    /**
     * Handle the updates to the navigation states using the NavigationListener
     * - Use CameraChangeListener to observe camera tracking mode and detect if the camera is locked on the chevron. If the user starts to move the camera, it will change and you can adjust the UI to suit.
     * - Use the SimulationLocationProvider for testing purposes.
     * - Once navigation is started, the camera is set to follow the user position, and the location indicator is changed to a chevron. To match raw location updates to the routes, use MapMatchedLocationProvider and set it to the TomTomMap.
     * - Set the bottom padding on the map. The padding sets a safe area of the MapView in which user interaction is not received. It is used to uncover the chevron in the navigation panel.
     */
    private val navigationListener = object : NavigationFragment.NavigationListener {
        override fun onStarted() {
            tomTomMap.addCameraChangeListener(cameraChangeListener)
            tomTomMap.cameraTrackingMode = CameraTrackingMode.FollowRoute
            tomTomMap.enableLocationMarker(
                LocationMarkerOptions(
                    LocationMarkerOptions.Type.Chevron)
            )
            setMapMatchedLocationProvider()
            setSimulationLocationProviderToNavigation(route!!)
            setMapNavigationPadding()
        }

        override fun onFailed(failure: NavigationFailure) {
            Toast.makeText(context, failure.message, Toast.LENGTH_SHORT).show()
            stopNavigation()
        }

        override fun onStopped() {
            stopNavigation()
        }
    }

    private val progressUpdatedListener = ProgressUpdatedListener {
        tomTomMap.routes.first().progress = it.distanceAlongRoute
    }

    private val routeUpdatedListener by lazy {
        RouteUpdatedListener { route, updateReason ->
            if (updateReason != RouteUpdateReason.Refresh &&
                updateReason != RouteUpdateReason.Increment &&
                updateReason != RouteUpdateReason.LanguageChange
            ) {
                tomTomMap.removeRoutes()
                drawRoute(route)
            }
        }
    }

    /**
     * Use the SimulationLocationProvider for testing purposes.
     */
    private fun setSimulationLocationProviderToNavigation(route: Route) {
        val routeGeoLocations = route.geometry.map { GeoLocation(it) }
        val simulationStrategy = InterpolationStrategy(routeGeoLocations)
        locationProvider = SimulationLocationProvider.create(strategy = simulationStrategy)
        tomTomNavigation.locationProvider = locationProvider
        locationProvider.enable()
    }

    /**
     * Stop the navigation process using NavigationFragment.
     * This hides the UI elements and calls the TomTomNavigation.stop() method.
     * Don’t forget to reset any map settings that were changed, such as camera tracking, location marker, and map padding.
     */
    private fun stopNavigation() {

        navigationFragment.stopNavigation()
        mapFragment.currentLocationButton.visibilityPolicy =
            CurrentLocationButton.VisibilityPolicy.InvisibleWhenRecentered
        tomTomMap.removeCameraChangeListener(cameraChangeListener)
        tomTomMap.cameraTrackingMode = CameraTrackingMode.None
        tomTomMap.enableLocationMarker(
            LocationMarkerOptions(
                LocationMarkerOptions.Type.Pointer)
        )
        resetMapPadding()
        navigationFragment.removeNavigationListener(navigationListener)
        tomTomNavigation.removeProgressUpdatedListener(progressUpdatedListener)
        tomTomNavigation.removeRouteUpdatedListener(routeUpdatedListener)
        clearMap()
        hideNavigation()
        initLocationProvider()
        enableUserLocation()
    }

    /**
     * Set the bottom padding on the map. The padding sets a safe area of the MapView in which user interaction is not received. It is used to uncover the chevron in the navigation panel.
     */
    private fun setMapNavigationPadding() {
        val paddingBottom = 280 // resources.getDimensionPixelOffset(R.dimen.map_padding_bottom)
        val padding = Padding(0, 0, 0, paddingBottom)
        setPadding(padding)
    }

    private fun setPadding(padding: Padding) {
        val scale: Float = context.getFragmentActivityOrThrow().resources.displayMetrics.density

        val paddingInPixels = Padding(
            top = (padding.top * scale).toInt(),
            left = (padding.left * scale).toInt(),
            right = (padding.right * scale).toInt(),
            bottom = (padding.bottom * scale).toInt()
        )
        println("setting padding (in pixels) to $paddingInPixels, from $padding")
        tomTomMap.setPadding(paddingInPixels)
    }

    private fun resetMapPadding() {
        tomTomMap.setPadding(Padding(0, 0, 0, 0))
    }

    /**
     * Once navigation is started, the camera is set to follow the user position, and the location indicator is changed to a chevron.
     * To match raw location updates to the routes, use MapMatchedLocationProvider and set it to the TomTomMap.
     */
    private fun setMapMatchedLocationProvider() {
        val mapMatchedLocationProvider = MapMatchedLocationProvider(tomTomNavigation)
        tomTomMap.setLocationProvider(mapMatchedLocationProvider)
        mapMatchedLocationProvider.enable()
    }

    /**
     *
     * The method removes all polygons, circles, routes, and markers that were previously added to the map.
     */
    private fun clearMap() {
        tomTomMap.clear()
    }

//    private fun requestLocationPermission() {
//        locationPermissionRequest.launch(
//            arrayOf(
//                Manifest.permission.ACCESS_FINE_LOCATION,
//                Manifest.permission.ACCESS_COARSE_LOCATION
//            )
//        )
//    }

    private val cameraChangeListener by lazy {
        CameraChangeListener {
//            val cameraTrackingMode = tomTomMap.cameraTrackingMode
//            if (cameraTrackingMode == CameraTrackingMode.FollowRoute) {
//                navigationFragment.navigationView.showSpeedView()
//            } else {
//                navigationFragment.navigationView.hideSpeedView()
//            }
        }
    }

//    private val locationPermissionRequest = context.getFragmentActivityOrThrow().registerForActivityResult(
//        ActivityResultContracts.RequestMultiplePermissions()
//    ) { permissions ->
//        if (permissions[Manifest.permission.ACCESS_FINE_LOCATION] == true &&
//            permissions[Manifest.permission.ACCESS_COARSE_LOCATION] == true
//        ) {
//            showUserLocation()
//        } else {
//            Toast.makeText(
//                context,
//                "No Location permissions!", //getString(R.string.location_permission_denied),
//                Toast.LENGTH_SHORT
//            ).show()
//        }
//    }

    private fun areLocationPermissionsGranted() = ContextCompat.checkSelfPermission(
        context,
        Manifest.permission.ACCESS_FINE_LOCATION
    ) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(
        context,
        Manifest.permission.ACCESS_COARSE_LOCATION
    ) == PackageManager.PERMISSION_GRANTED

    companion object {
        private const val ZOOM_TO_ROUTE_PADDING = 100
    }
}