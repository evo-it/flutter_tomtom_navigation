package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import android.content.ContextWrapper
import android.view.View
import androidx.core.view.doOnAttach
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import com.tomtom.sdk.map.display.MapOptions
import com.tomtom.sdk.map.display.ui.MapFragment
import io.flutter.plugin.platform.PlatformView
import kotlin.random.Random

class FlutterTomtomNavigationView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val fragment: MapFragment
    private val view: View

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        fragment.onDestroyView()
    }

    init {
        // Get the API key from the creation params
        val apiKey = creationParams?.get("apiKey") as String
        fragment = MapFragment.newInstance(MapOptions(mapKey=apiKey))

        view = FragmentContainerView(context)
        view.id = Random.nextInt()

        view.doOnAttach {
            val activity = it.context.getFragmentActivityOrThrow()
            activity.supportFragmentManager.findFragmentByTag("flutter_fragment")?.childFragmentManager?.beginTransaction()
                ?.replace(it.id, fragment)?.commit()
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
}