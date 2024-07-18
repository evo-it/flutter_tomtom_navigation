package com.tomtom.flutter_tomtom_navigation_android

import android.content.Context
import com.tomtom.quantity.Distance
import com.tomtom.sdk.navigation.GuidanceUpdatedListener
import com.tomtom.sdk.navigation.guidance.GuidanceAnnouncement
import com.tomtom.sdk.navigation.guidance.InstructionPhase
import com.tomtom.sdk.navigation.guidance.instruction.GuidanceInstruction
import com.tomtom.sdk.tts.android.AndroidTextToSpeechEngine
import com.tomtom.sdk.tts.engine.AudioMessage
import com.tomtom.sdk.tts.engine.MessagePlaybackListener
import com.tomtom.sdk.tts.engine.MessageType
import com.tomtom.sdk.tts.engine.TextToSpeechEngineError

class FlutterTomtomGuidanceUpdatedListener(context: Context) :
    GuidanceUpdatedListener {
    private val tts = AndroidTextToSpeechEngine(context)

    private val playbackListener = object : MessagePlaybackListener {
        override fun onDone() {}
        override fun onError(error: TextToSpeechEngineError) {}
        override fun onStart() {}
        override fun onStop() {}
    }

    override fun onAnnouncementGenerated(
        announcement: GuidanceAnnouncement,
        shouldPlay: Boolean
    ) {
        println("Announcement generated ${announcement.plainTextMessage} ($shouldPlay)")
        // Make sure the language is correct for the message
        if (announcement.language != tts.currentLanguage()) {
            tts.changeLanguage(announcement.language)
        }

        // Only play if it should play
        if (!shouldPlay) return

        // Play the message
        println("Playing message...")
        tts.playAudioMessage(
            AudioMessage(announcement.plainTextMessage, MessageType.Plain),
            playbackListener,
        )
    }

    override fun onDistanceToNextInstructionChanged(
        distance: Distance,
        instructions: List<GuidanceInstruction>,
        currentPhase: InstructionPhase
    ) {
    }

    override fun onInstructionsChanged(instructions: List<GuidanceInstruction>) {}
}
