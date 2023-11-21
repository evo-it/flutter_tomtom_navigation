package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.GsonBuilder
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.RouteTypeAdapter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleDeserializer
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.calculation.RouteType
import com.tomtom.sdk.routing.options.guidance.AnnouncementPoints
import com.tomtom.sdk.routing.options.guidance.ExtendedSections
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.routing.options.guidance.InstructionPhoneticsType
import com.tomtom.sdk.routing.options.guidance.InstructionType
import com.tomtom.sdk.routing.options.guidance.ProgressPoints
import com.tomtom.sdk.vehicle.Vehicle

class RoutePlanningOptionsDeserializer {
    companion object {
        fun deserialize(
            arguments: String,
            currentLocation: GeoPoint
        ): RoutePlanningOptions {
            val builder = GsonBuilder()
            builder.registerTypeAdapter(
                RouteType::class.java,
                RouteTypeAdapter(),
            )
            builder.registerTypeAdapter(
                Vehicle::class.java,
                VehicleDeserializer(),
            )
            val gson = builder.create()

            println("Android options is $arguments")
            val opt = gson.fromJson(arguments, RoutePlanningOptions::class.java)
            println("Deserialized to $opt")
            return opt.copy(
                guidanceOptions = GuidanceOptions(
                    instructionType = InstructionType.Text,
                    phoneticsType = InstructionPhoneticsType.Ipa,
                    announcementPoints = AnnouncementPoints.All,
                    extendedSections = ExtendedSections.All,
                    progressPoints = ProgressPoints.All
                ),
                routeLegOptions = emptyList()
            )
        }
    }
}
