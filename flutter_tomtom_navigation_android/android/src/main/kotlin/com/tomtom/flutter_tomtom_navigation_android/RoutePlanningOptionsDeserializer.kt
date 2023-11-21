package com.tomtom.flutter_tomtom_navigation_android

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.RouteTypeAdapter
import com.tomtom.flutter_tomtom_navigation_android.type_adapters.VehicleDeserializer
import com.tomtom.quantity.Speed
import com.tomtom.sdk.location.GeoPoint
import com.tomtom.sdk.routing.options.RoutePlanningOptions
import com.tomtom.sdk.routing.options.calculation.CostModel
import com.tomtom.sdk.routing.options.calculation.RouteType
import com.tomtom.sdk.routing.options.guidance.GuidanceOptions
import com.tomtom.sdk.vehicle.AdrTunnelRestrictionCode
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.VehicleDimensions
import com.tomtom.sdk.vehicle.VehicleLoadType
import com.tomtom.sdk.vehicle.VehicleType

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
            return opt.copy(guidanceOptions = GuidanceOptions(), routeLegOptions = emptyList())
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
