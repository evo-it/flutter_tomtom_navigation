package com.tomtom.flutter_tomtom_navigation_android.type_adapters

import android.net.Uri
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.tomtom.sdk.map.display.style.StyleDescriptor
import java.lang.reflect.Type

class StyleDescriptorDeserializer : JsonDeserializer<StyleDescriptor> {
    override fun deserialize(
        json: JsonElement,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): StyleDescriptor {
        val o = json.asJsonObject

        val uri = Uri.parse(o.get("uri").asString)
        val darkUri =
            if (o.has("darkUri") && !o["darkUri"].isJsonNull) Uri.parse(o.get("darkUri").asString) else null
        val layerMappingUri =
            if (o.has("layerMappingUri") && !o["layerMappingUri"].isJsonNull) Uri.parse(
                o.get("layerMappingUri").asString
            ) else null
        val darkLayerMappingUri =
            if (o.has("darkLayerMappingUri") && !o["darkLayerMappingUri"].isJsonNull) Uri.parse(
                o.get("darkLayerMappingUri").asString
            ) else null
        return StyleDescriptor(
            uri = uri,
            darkUri = darkUri,
            layerMappingUri = layerMappingUri,
            darkLayerMappingUri = darkLayerMappingUri,
        )
    }
}
