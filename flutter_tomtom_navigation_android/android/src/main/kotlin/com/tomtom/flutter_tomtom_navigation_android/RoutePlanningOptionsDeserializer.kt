package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.Gson
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.location.Place
import com.tomtom.sdk.routing.options.Itinerary
import com.tomtom.sdk.routing.options.ItineraryPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.VehicleDimensions
import com.tomtom.sdk.vehicle.VehicleType
import java.lang.IllegalArgumentException

class RoutePlanningOptionsDeserializer {
    companion object {
        fun deserialize(
            arguments: Map<*, *>,
            currentLocation: GeoPoint
        ): RoutePlanningOptions {
            val gson = Gson()

            // The itinerary
            if (!arguments.containsKey("destination") || !arguments.containsKey(
                    "vehicleType"
                )
            ) {
                throw IllegalArgumentException("Required arguments not passed when planning a route: ${arguments.keys}!");
            }
            val origin = ItineraryPoint(Place(currentLocation))
            val destination = gson.fromJson(
                arguments["destination"] as String,
                ItineraryPoint::class.java
            )

            // The vehicle (and dimensions)
            val vehicleType = arguments["vehicleType"] as Int
            val vehicleDimensions =
                if (arguments["vehicleDimensions"] != null) gson.fromJson(
                    arguments["vehicleDimensions"] as String,
                    VehicleDimensions::class.java
                ) else null
            val vehicle = getVehicle(vehicleType, vehicleDimensions)

            println("vehicle is $vehicle")
            return RoutePlanningOptions(
                itinerary = Itinerary(
                    origin = origin,
                    destination = destination
                ),
                vehicle = vehicle,
            )
        }

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