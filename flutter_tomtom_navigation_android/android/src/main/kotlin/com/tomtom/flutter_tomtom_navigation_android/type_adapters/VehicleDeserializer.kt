package com.tomtom.flutter_tomtom_navigation_android.type_adapters

import com.google.gson.Gson
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.tomtom.sdk.vehicle.Vehicle
import com.tomtom.sdk.vehicle.VehicleLoadType
import java.lang.reflect.Type

class VehicleDeserializer : JsonDeserializer<Vehicle> {
    override fun deserialize(
        json: JsonElement,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): Vehicle {
        val gson = Gson()

        return when (json.asJsonObject.get("type").asInt) {
            0 -> gson.fromJson(json, Vehicle.Car::class.java)
            1 -> gson.fromJson(json, Vehicle.Truck::class.java)
            2 -> gson.fromJson(json, Vehicle.Taxi::class.java)
            3 -> gson.fromJson(json, Vehicle.Bus::class.java)
            4 -> gson.fromJson(json, Vehicle.Van::class.java)
            5 -> gson.fromJson(json, Vehicle.Motorcycle::class.java)
            6 -> gson.fromJson(json, Vehicle.Bicycle::class.java)
            7 -> gson.fromJson(json, Vehicle.Pedestrian::class.java)
            else -> gson.fromJson(json, Vehicle.Car::class.java)
        }
    }
}
