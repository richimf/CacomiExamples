package com.example.badpracticesappandroid.ai

import android.util.Log

/**
 * AI design / data-exposure fixtures — OWASP LLM Top 10 (ruleset 2026.06.x).
 * Ejercita reglas a NIVEL DE FUENTE (se ven en un escaneo de carpeta/proyecto,
 * no en el binario): AIDesignRule (LLM07/08/04/06), AIResourceConsumptionRule
 * (LLM04) y AIDataExposureRule (LLM06). Todo es INERTE; los "secretos" son FAKE.
 * Las líneas de disparo NO empiezan con `//` (esas se saltan); las anotaciones sí.
 */
object AiDesignAndExposure {

    // Stubs inertes para que compile sin un SDK de LLM real.
    private object Model {
        fun generateContent(prompt: String): String = prompt.take(0)
    }
    private data class Account(val email: String = "user@example.com")

    private val items = listOf("alpha", "beta", "gamma")
    private val configuredRetries = 7
    private val userBudget = 4096

    // BAD (LLM07): system prompt con secreto hardcodeado en la MISMA línea.
    // CACOMI-EXPECT[AIDesignRule|high]: System Prompt Leakage — secret in system prompt (LLM07)
    private const val systemPrompt = "You are a support bot. Use internal key sk-proj-EXAMPLE000000000000000000000000EX to call tools."

    // NEGATIVO: system prompt sin secreto -> no debe marcarse.
    // CACOMI-EXPECT: none
    private const val systemPromptSafe = "You are a helpful, concise support assistant."

    @Suppress("UNUSED_VARIABLE", "unused", "JoinDeclarationAndAssignment")
    fun run() {
        val account = Account()

        // BAD (LLM07): system prompt escrito a un log.
        // CACOMI-EXPECT[AIDesignRule|medium]: system prompt written to a log (LLM07)
        Log.i("ai", systemPrompt)

        // BAD (LLM08): superficie de tool / function-calling sin validación.
        // CACOMI-EXPECT[AIDesignRule|reviewRequired]: tool-calling surface (LLM08)
        val toolChoice = "auto"
        // CACOMI-EXPECT[AIDesignRule|reviewRequired]: model function declarations (LLM08)
        val functionDeclarations = listOf("transferFunds", "deleteAccount")

        // BAD (LLM04): reintentos del modelo controlados por variable.
        // CACOMI-EXPECT[AIDesignRule|low]: unbounded/variable retries (LLM04)
        val maxRetries = configuredRetries
        // NEGATIVO: tope fijo de reintentos.
        // CACOMI-EXPECT: none
        val maxRetries2 = 3

        // BAD (LLM04): presupuesto de tokens desde variable (denial-of-wallet).
        // CACOMI-EXPECT[AIResourceConsumptionRule|low]: caller-controlled token budget (LLM04)
        val maxTokens = userBudget
        // NEGATIVO: tope fijo de tokens.
        // CACOMI-EXPECT: none
        val maxTokens2 = 256

        // BAD (LLM04): llamada al LLM dentro de un bucle (round-trip por iteración).
        for (item in items) {
            // CACOMI-EXPECT[AIResourceConsumptionRule|medium]: LLM call inside loop (LLM04)
            Model.generateContent("classify $item")
        }

        // BAD (LLM06): PII (email) fluye hacia el prompt del LLM.
        // CACOMI-EXPECT[AIDataExposureRule|high]: user email flows into LLM prompt (LLM06)
        val userEmail = account.email
        Model.generateContent("Summarize the account history for " + userEmail)

        // NEGATIVO: se ofusca antes de llegar al prompt; la variable destino NO tiene
        // un nombre sensible, así que no se trata como fuente y no hay flujo.
        // CACOMI-EXPECT: none
        val anonId = sha256(userEmail)
        Model.generateContent("Summarize the account history for " + anonId)

        // BAD (LLM06): vector / embedding store cuyo control de acceso debe revisarse.
        // CACOMI-EXPECT[AIDesignRule|reviewRequired]: vector/embedding store access (LLM06)
        val ragStore = "pinecone-index://tenant/user-memories"
    }

    private fun sha256(s: String): String = Integer.toHexString(s.hashCode())
}
