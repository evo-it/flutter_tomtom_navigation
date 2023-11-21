package com.tomtom.flutter_tomtom_navigation_android.type_adapters

import com.google.gson.Gson
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.tomtom.sdk.vehicle.Vehicle
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
            else -> gson.fromJson(json, Vehicle.Car::class.java)
        }
    }
}
