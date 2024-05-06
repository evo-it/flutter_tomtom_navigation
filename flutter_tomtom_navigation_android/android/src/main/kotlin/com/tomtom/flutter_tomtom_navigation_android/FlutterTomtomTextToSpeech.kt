package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import com.tomtom.sdk.tts.android.AndroidTextToSpeechEngine
import com.tomtom.sdk.tts.engine.AudioMessage
import com.tomtom.sdk.tts.engine.MessagePlaybackListener
import com.tomtom.sdk.tts.engine.MessageType
import com.tomtom.sdk.tts.engine.OnEngineReadyListener
import com.tomtom.sdk.tts.engine.TextToSpeechEngine
import com.tomtom.sdk.tts.engine.phonetics.TaggedMessage
import java.util.Locale

class FlutterTomtomTextToSpeech(context: Context, language: Locale) : TextToSpeechEngine {
    private val tts: AndroidTextToSpeechEngine =
        AndroidTextToSpeechEngine(context, language)
    override val supportedPhoneticAlphabets: List<String>
        get() = tts.supportedPhoneticAlphabets

    override fun addOnEngineReadyListener(listener: OnEngineReadyListener) {
        tts.addOnEngineReadyListener(listener)
    }

    override fun changeLanguage(language: Locale) {
        tts.changeLanguage(language)
    }

    override fun close() {
        tts.close()
    }

    override fun currentLanguage(): Locale? {
        return tts.currentLanguage()
    }

    override fun isLanguageAvailable(language: Locale): Boolean {
        return tts.isLanguageAvailable(language)
    }

    override fun playAudioMessage(
        audioMessage: AudioMessage,
        playbackListener: MessagePlaybackListener
    ) {
        if (audioMessage.messageType == MessageType.Ssml) {
            val message =
                audioMessage.message.replace("ph=\"ˌɛn.", "ph=\"ˌɛn. ")
                    .replace("ph=\"a.", "ph=\"a. ")
            tts.playAudioMessage(
                AudioMessage(message, MessageType.Ssml),
                playbackListener
            )
        } else {
            tts.playAudioMessage(audioMessage, playbackListener)
        }
    }

    override fun playTaggedMessage(
        taggedMessage: TaggedMessage,
        playbackListener: MessagePlaybackListener
    ) {
        tts.playTaggedMessage(taggedMessage, playbackListener)
    }

    override fun removeOnEngineReadyListener(listener: OnEngineReadyListener) {
        tts.removeOnEngineReadyListener(listener)
    }

    override fun stopMessagePlayback() {
        tts.stopMessagePlayback()
    }
}
