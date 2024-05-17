package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.GsonBuilder
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.RouteTypeAdapter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleDeserializer
import com.tomtom.sdk.annotations.InternalTomTomSdkApi
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.Place
import com.tomtom.sdk.routing.options.Itinerary
import com.tomtom.sdk.routing.options.ItineraryPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.calculation.RouteType
import com.tomtom.sdk.routing.options.guidance.ExtendedSections
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.routing.options.guidance.InstructionPhoneticsType
import com.tomtom.sdk.routing.options.guidance.RoadShieldReferences
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.Vehicle.*
import java.util.Locale

class RoutePlanningOptionsDeserializer {
    companion object {
        @OptIn(InternalTomTomSdkApi::class)
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
            return opt.copy(
                // TODO once navigation can handle it, either use the normal vehicle or remove the guidance options
                guidanceOptions = GuidanceOptions(
                    roadShieldReferences = RoadShieldReferences.None,
                    phoneticsType = InstructionPhoneticsType.Ipa,
                    extendedSections = ExtendedSections.All,
                    language = Locale.getDefault(),
                ),
                itinerary = Itinerary(
                    // Replace the origin with the current location if an origin point of 0 was passed
                    origin = if (opt.itinerary.origin.place.coordinate == ZERO)
                        ItineraryPoint(Place(currentLocation))
                    else opt.itinerary.origin,
                    waypoints = opt.itinerary.waypoints,
                    destination = opt.itinerary.destination,
                ),
                vehicle = if (opt.vehicle is Van) Car(
                    maxSpeed = (opt.vehicle as Van).maxSpeed,
                    isCommercial = (opt.vehicle as Van).isCommercial,
                    electricEngine = (opt.vehicle as Van).electricEngine,
                    combustionEngine = (opt.vehicle as Van).combustionEngine,
                    dimensions = (opt.vehicle as Van).dimensions,
                    modelId = (opt.vehicle as Van).modelId,
                ) else opt.vehicle
            )
        }

        val ZERO = GeoPoint(0.0, 0.0)
    }
}
