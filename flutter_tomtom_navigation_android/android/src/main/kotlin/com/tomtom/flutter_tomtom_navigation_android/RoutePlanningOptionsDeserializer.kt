package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.GsonBuilder
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.RouteTypeAdapter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleDeserializer
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.Place
import com.tomtom.sdk.routing.options.Itinerary
import com.tomtom.sdk.routing.options.ItineraryPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.calculation.RouteType
import com.tomtom.sdk.routing.options.guidance.AnnouncementPoints
import com.tomtom.sdk.routing.options.guidance.ExtendedSections
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.routing.options.guidance.InstructionPhoneticsType
import com.tomtom.sdk.routing.options.guidance.InstructionType
import com.tomtom.sdk.routing.options.guidance.OnlineApiVersion
import com.tomtom.sdk.routing.options.guidance.ProgressPoints
import com.tomtom.sdk.vehicle.Vehicle
import java.util.Locale

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

            // For now, use the default locale that is set on app launch
            // TODO retrieve guidance options from Flutter
            return opt.copy(
                guidanceOptions = GuidanceOptions(
                    guidanceVersion = OnlineApiVersion.v1,
                    instructionType = InstructionType.Coded,
                    phoneticsType = InstructionPhoneticsType.Ipa,
                    announcementPoints = AnnouncementPoints.All,
                    extendedSections = ExtendedSections.All,
                    progressPoints = ProgressPoints.All,
                    language = Locale.getDefault(),
                ),
                itinerary = Itinerary(
                    // For now, always replace the origin with the current location
                    origin = ItineraryPoint(Place(currentLocation)),
                    waypoints = opt.itinerary.waypoints,
                    destination = opt.itinerary.destination,
                )
            )
        }
    }
}
