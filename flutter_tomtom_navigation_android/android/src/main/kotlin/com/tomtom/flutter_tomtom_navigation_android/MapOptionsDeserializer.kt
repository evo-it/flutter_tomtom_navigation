package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.GsonBuilder
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.StyleDescriptorDeserializer
import com.tomtom.sdk.map.display.MapOptions
import com.tomtom.sdk.map.display.style.StyleDescriptor
import com.tomtom.sdk.map.display.map.OnlineCachePolicy

class MapOptionsDeserializer {
    companion object {
        fun deserialize(
            arguments: String,
        ): MapOptions {
            val builder = GsonBuilder()
            builder.registerTypeAdapter(
                StyleDescriptor::class.java,
                StyleDescriptorDeserializer(),
            )
            val gson = builder.create()
            val opt =  gson.fromJson(arguments, MapOptions::class.java)

            return MapOptions(
                opt.mapKey,
                cameraOptions = opt.cameraOptions,
                padding = opt.padding,
                mapStyle = opt.mapStyle,
                styleMode = opt.styleMode,
                onlineCachePolicy = OnlineCachePolicy.Default,
                renderToTexture = opt.renderToTexture,
            )
        }
    }
}