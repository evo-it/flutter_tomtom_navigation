package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import android.content.ContextWrapper
import android.view.View
import android.widget.Button
import android.widget.RelativeLayout
import androidx.core.view.doOnAttach
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.LocationProvider
import com.tomtom.sdk.location.android.AndroidLocationProvider
import com.tomtom.sdk.map.display.MapOptions
import com.tomtom.sdk.map.display.TomTomMap
import com.tomtom.sdk.map.display.camera.CameraOptions
import com.tomtom.sdk.map.display.ui.MapFragment
import com.tomtom.sdk.navigation.TomTomNavigation
import com.tomtom.sdk.navigation.online.Configuration
import com.tomtom.sdk.navigation.online.OnlineTomTomNavigationFactory
import com.tomtom.sdk.navigation.routereplanner.RouteReplanner
import com.tomtom.sdk.navigation.routereplanner.online.OnlineRouteReplannerFactory
import com.tomtom.sdk.navigation.ui.NavigationFragment
import com.tomtom.sdk.navigation.ui.NavigationUiOptions
import com.tomtom.sdk.routing.RoutePlanner
import com.tomtom.sdk.routing.online.OnlineRoutePlanner
import com.tomtom.sdk.vehicle.DefaultVehicleProvider
import com.tomtom.sdk.vehicle.Vehicle
import io.flutter.plugin.platform.PlatformView
import kotlin.random.Random

class FlutterTomtomNavigationView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?
) : PlatformView {
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
    private val locationProvider: LocationProvider
    private val routePlanner: RoutePlanner

    private val routeReplanner: RouteReplanner
    private val tomTomNavigation: TomTomNavigation

    override fun dispose() {
        tomTomNavigation.close()
        routeReplanner.close()

        routePlanner.close()
        locationProvider.close()
    }

    init {
        // Get the API key from the creation params
        val apiKey = creationParams?.get("apiKey") as String

        // The root view is a RelativeLayout
        relativeLayout = RelativeLayout(context)

        // This layout contains two views: the map view...
        val mapFragment = MapFragment.newInstance(MapOptions(mapKey = apiKey))
        mapFragmentContainer = FragmentContainerView(context)
        mapFragmentContainer.id = Random.nextInt()
        mapFragmentContainer.doOnAttach {
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, mapFragment)?.commit()
        }
        relativeLayout.addView(mapFragmentContainer)

        // ...and the navigation view
        val navigationFragment = NavigationFragment.newInstance(
            NavigationUiOptions()
        )

        navigationFragmentContainer = FragmentContainerView(context)
        navigationFragmentContainer.id = Random.nextInt()

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
            if(navigationFragmentContainer.visibility == View.VISIBLE) {
                hideNavigation()
            } else {
                showNavigation()
            }
        }

        relativeLayout.addView(button)

        // Map display and route planning:
        routePlanner = OnlineRoutePlanner.create(context, apiKey)
        locationProvider = AndroidLocationProvider(context)
        locationProvider.enable()
        mapFragment.getMapAsync {
            tomTomMap = it
            tomTomMap.setLocationProvider(locationProvider)
            tomTomMap.moveCamera(CameraOptions(GeoPoint(52.0, 4.43), zoom = 10.0))
        }

        // Navigation and route re-planning:
        routeReplanner = OnlineRouteReplannerFactory.create(routePlanner)
        val configuration = Configuration(
            context = context,
            apiKey = apiKey,
            locationProvider = locationProvider,
            routeReplanner = routeReplanner,
            vehicleProvider = DefaultVehicleProvider(vehicle = Vehicle.Car())
        )
        tomTomNavigation = OnlineTomTomNavigationFactory.create(configuration)
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

    fun showNavigation() {
        navigationFragmentContainer.visibility = View.VISIBLE
    }

    fun hideNavigation() {
        navigationFragmentContainer.visibility = View.INVISIBLE
    }
}