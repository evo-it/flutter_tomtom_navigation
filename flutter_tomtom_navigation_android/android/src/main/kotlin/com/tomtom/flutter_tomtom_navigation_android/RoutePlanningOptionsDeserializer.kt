package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonToken
import com.google.gson.stream.JsonWriter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.RouteTypeAdapter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleDeserializer
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleTypeAdapter
import com.tomtom.quantity.Distance
import com.tomtom.quantity.Speed
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.Place
import com.tomtom.sdk.navigation.horizon.elements.vehiclerestriction.VehicleRestrictionData
import com.tomtom.sdk.routing.options.Itinerary
import com.tomtom.sdk.routing.options.ItineraryPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.calculation.AvoidOptions
import com.tomtom.sdk.routing.options.calculation.AvoidType
import com.tomtom.sdk.routing.options.calculation.CostModel
import com.tomtom.sdk.routing.options.calculation.RouteType
import com.tomtom.sdk.routing.options.guidance.AnnouncementPoints
import com.tomtom.sdk.routing.options.guidance.ExtendedSections
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.routing.options.guidance.InstructionPhoneticsType
import com.tomtom.sdk.routing.options.guidance.InstructionType
import com.tomtom.sdk.routing.options.guidance.ProgressPoints
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.VehicleDimensions
import com.tomtom.sdk.vehicle.VehicleType
import java.io.IOException


class RoutePlanningOptionsDeserializer {
    companion object {
        fun deserialize(
            arguments: String,
            currentLocation: GeoPoint
        ): RoutePlanningOptions {
            println(Gson().toJson(Vehicle.Car(modelId = "Focus")))
            println(
                Gson().toJson(
                    Vehicle.Truck(
                        maxSpeed = Speed.Companion.kilometersPerHour(
                            80
                        )
                    )
                )
            )

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

//            // The itinerary
//            if (!arguments.containsKey("destination")
//                || !arguments.containsKey("vehicleType")
//                || !arguments.containsKey("costModel")
//            ) {
//                throw IllegalArgumentException("Required arguments not passed when planning a route: ${arguments.keys}!");
//            }
//            val origin = ItineraryPoint(Place(currentLocation))
//            val destination = gson.fromJson(
//                arguments["destination"] as String,
//                ItineraryPoint::class.java
//            )
////            val origin = GeoPoint(51.450751, 5.003712)
////            val destination = GeoPoint(51.421169, 5.096239)
//
//            // The vehicle (and dimensions)
//            val vehicleType = arguments["vehicleType"] as Int
//            val vehicleDimensions =
//                if (arguments["vehicleDimensions"] != null) gson.fromJson(
//                    arguments["vehicleDimensions"] as String,
//                    VehicleDimensions::class.java
//                ) else null
//            val vehicle = getVehicle(vehicleType, vehicleDimensions)
//            println(arguments["costModel"])
//            val costModel = gson.fromJson(
//                arguments["costModel"] as String,
//                CostModel::class.java
//            )
//            return RoutePlanningOptions(
//                itinerary = Itinerary(
//                    origin = origin,
//                    destination = destination,
//                ),
//                costModel = costModel,
//                guidanceOptions = GuidanceOptions(
//                    instructionType = InstructionType.Text,
//                    phoneticsType = InstructionPhoneticsType.Ipa,
//                    announcementPoints = AnnouncementPoints.All,
//                    extendedSections = ExtendedSections.All,
//                    progressPoints = ProgressPoints.All
//                ),
//                vehicle = vehicle,
//            )
            return RoutePlanningOptions(
                itinerary = Itinerary(
                    origin = currentLocation,
                    destination = GeoPoint(52.2, 4.38),
                )
            )
        }

        /**
         * TODO Can we read these from the [VehicleType] value class instead?
         */
        private fun getVehicle(
            vehicleType: Int,
            dimensions: VehicleDimensions?
        ): Vehicle {
            return when (vehicleType) {
                0 -> Vehicle.Car(dimensions = dimensions)
                1 -> Vehicle.Truck(dimensions = dimensions)
                2 -> Vehicle.Taxi(dimensions = dimensions)
                3 -> Vehicle.Bus(dimensions = dimensions)
                4 -> Vehicle.Van(dimensions = dimensions)
                5 -> Vehicle.Motorcycle(dimensions = dimensions)
                6 -> Vehicle.Bicycle()
                7 -> Vehicle.Pedestrian()
                else -> {
                    println("Invalid vehicle type. Defaulting to Vehicle.Car")
                    return Vehicle.Car(dimensions = dimensions)
                }
            }
        }
    }
}
