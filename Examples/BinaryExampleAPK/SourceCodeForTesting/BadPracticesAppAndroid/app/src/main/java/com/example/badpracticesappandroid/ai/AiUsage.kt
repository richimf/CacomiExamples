package com.example.badpracticesappandroid.ai

import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

/**
 * Equivalente Android de AIUsage.swift — AIDiscoveryRule.
 * Endpoints de proveedores de IA + referencia a modelo on-device (ML Kit / TFLite).
 */
object AiUsage {

    // BAD: endpoint OpenAI chat completions // CACOMI-EXPECT: AIDiscoveryRule
    const val OPENAI_CHAT = "https://api.openai.com/v1/chat/completions"

    // BAD: endpoint Anthropic messages // CACOMI-EXPECT: AIDiscoveryRule
    const val ANTHROPIC_MESSAGES = "https://api.anthropic.com/v1/messages"

    // BAD: endpoint Google Gemini // CACOMI-EXPECT: AIDiscoveryRule
    const val GEMINI = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

    // BAD: referencia a modelo on-device (TFLite / ML Kit) // CACOMI-EXPECT: AIDiscoveryRule
    const val MODEL_FILE = "model.tflite"
    const val MLKIT_PACKAGE = "com.google.mlkit.vision.label.ImageLabeling"

    private const val OPENAI_API_KEY = "sk-proj-EXAMPLE000000000000000000000000000000000000EX" // dummy

    fun callAnthropic(client: OkHttpClient): Request {
        val body = """{"model":"claude-3","max_tokens":16,"messages":[{"role":"user","content":"hi"}]}"""
            .toRequestBody()
        return Request.Builder()
            .url(ANTHROPIC_MESSAGES)
            .addHeader("x-api-key", OPENAI_API_KEY) // dummy
            .addHeader("anthropic-version", "2023-06-01")
            .post(body)
            .build()
    }
}
