package com.example.badpracticesappandroid.trackers

import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

/**
 * Familia 14: Trackers / dependencias / AI (TrackerDetection / AIDiscovery).
 */
object TrackersAndAi {

    // BAD: referencia (por string) a SDKs tracker conocidos // CACOMI-EXPECT: TrackerDetection
    const val FACEBOOK_SDK = "com.facebook.sdk.ApplicationId"
    const val ADJUST_ENDPOINT = "https://app.adjust.com/track"
    const val FIREBASE_ANALYTICS = "com.google.firebase.analytics.FirebaseAnalytics"
    const val AMPLITUDE_SDK = "com.amplitude.api.Amplitude"
    const val APPSFLYER_SDK = "com.appsflyer.AppsFlyerLib"
    // BAD: endpoints de trackers // CACOMI-EXPECT: TrackerDetection
    const val META_PIXEL = "https://graph.facebook.com/v17.0/123456789/activities"
    const val APPSFLYER_ENDPOINT = "https://events.appsflyer.com/api/v6.0/androidevent"

    // BAD: endpoint de proveedor de IA + uso de api_key // CACOMI-EXPECT: AIDiscovery
    private const val OPENAI_URL = "https://api.openai.com/v1/chat/completions"
    private const val OPENAI_API_KEY = "sk-proj-EXAMPLE000000000000000000000000000000000000EX" // dummy

    fun callOpenAi(client: OkHttpClient): Request {
        val body = """{"model":"gpt-4","messages":[{"role":"user","content":"hi"}]}"""
            .toRequestBody()
        return Request.Builder()
            .url(OPENAI_URL)
            .addHeader("Authorization", "Bearer $OPENAI_API_KEY")
            .post(body)
            .build()
    }
}
