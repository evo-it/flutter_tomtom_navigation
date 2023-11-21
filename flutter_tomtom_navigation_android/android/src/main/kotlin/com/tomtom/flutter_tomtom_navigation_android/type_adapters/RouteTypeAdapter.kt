package com.tomtom.flutter_tomtom_navigation_android.type_adapters

import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonToken
import com.google.gson.stream.JsonWriter
import com.tomtom.sdk.routing.options.calculation.RouteType

class RouteTypeAdapter : TypeAdapter<RouteType>() {
    override fun write(out: JsonWriter, value: RouteType?) {
        out.value(value.toString())
    }

    override fun read(`in`: JsonReader): RouteType {
        if (`in`.peek() == JsonToken.NULL) {
            `in`.nextNull()
            return RouteType.Fast
        }
        val type = `in`.nextString()
        return when (type) {
            "Fast" -> RouteType.Fast
            "Short" -> RouteType.Short
            "Efficient" -> RouteType.Efficient
            "Thrilling" -> RouteType.Thrilling()
            else -> RouteType.Fast
        }
    }
}
