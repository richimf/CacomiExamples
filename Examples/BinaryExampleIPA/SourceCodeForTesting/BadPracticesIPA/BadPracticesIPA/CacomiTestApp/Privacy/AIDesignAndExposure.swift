//
//  AIDesignAndExposure.swift
//  CacomiTestApp
//
//  AI design / data-exposure fixtures — OWASP LLM Top 10 (ruleset 2026.06.x).
//  Source-level rules (seen in a folder/source scan, not the binary):
//  AIDesignRule (LLM07/08/04/06), AIResourceConsumptionRule (LLM04),
//  AIDataExposureRule (LLM06). All INERT; "secrets" are FAKE.
//  Trigger lines must NOT start with `//` (comment lines are skipped).
//

import Foundation

enum AIDesignAndExposure {

    // Inert stubs so the fixture compiles without a real LLM SDK.
    private struct Model { func generateContent(_ prompt: String) -> String { prompt } }
    private struct Account { let email = "user@example.com" }

    static let configuredRetries = 7
    static let userBudget = 4096

    // BAD (LLM07): system prompt embeds a hardcoded secret on the same line.
    // CACOMI-EXPECT[AIDesignRule|high]: System Prompt Leakage — secret in system prompt (LLM07)
    static let systemPrompt = "You are a support bot. Use internal key sk-proj-EXAMPLE000000000000000000000000EX to call tools."

    // NEGATIVE: system prompt without a secret.
    // CACOMI-EXPECT: none
    static let systemPromptSafe = "You are a helpful, concise support assistant."

    // BAD (LLM08): tool / function-calling surface that needs validation.
    // CACOMI-EXPECT[AIDesignRule|reviewRequired]: tool-calling surface (LLM08)
    static let toolChoice = "auto"
    // CACOMI-EXPECT[AIDesignRule|reviewRequired]: model function declarations (LLM08)
    static let functionDeclarations = ["transferFunds", "deleteAccount"]

    // BAD (LLM04): model retries driven by a variable.
    // CACOMI-EXPECT[AIDesignRule|low]: unbounded/variable retries (LLM04)
    static let maxRetries = configuredRetries
    // NEGATIVE: fixed retry cap.
    // CACOMI-EXPECT: none
    static let maxRetriesFixed = 3

    // BAD (LLM04): caller-controlled token budget (denial-of-wallet).
    // CACOMI-EXPECT[AIResourceConsumptionRule|low]: caller-controlled token budget (LLM04)
    static let maxTokens = userBudget
    // NEGATIVE: fixed token budget.
    // CACOMI-EXPECT: none
    static let maxTokensFixed = 256

    // BAD (LLM06): vector / embedding store whose access control must be reviewed.
    // CACOMI-EXPECT[AIDesignRule|reviewRequired]: vector/embedding store access (LLM06)
    static let ragStore = "pinecone-index://tenant/user-memories"

    static func run() {
        let model = Model()
        let account = Account()
        let items = ["alpha", "beta", "gamma"]

        // BAD (LLM07): system prompt written to a log.
        // CACOMI-EXPECT[AIDesignRule|medium]: system prompt written to a log (LLM07)
        NSLog("ai systemPrompt = %@", systemPrompt)

        // BAD (LLM04): LLM call inside a loop (a paid round-trip per iteration).
        for item in items {
            // CACOMI-EXPECT[AIResourceConsumptionRule|medium]: LLM call inside loop (LLM04)
            _ = model.generateContent("classify \(item)")
        }

        // BAD (LLM06): PII (email) flows into the LLM prompt.
        // CACOMI-EXPECT[AIDataExposureRule|high]: user email flows into LLM prompt (LLM06)
        let userEmail = account.email
        _ = model.generateContent("Summarize the account history for \(userEmail)")

        // NEGATIVE: hashed before the prompt; the destination var has no sensitive
        // name, so it isn't treated as a source and no sensitive flow reaches the sink.
        // CACOMI-EXPECT: none
        let anonId = sha256(userEmail)
        _ = model.generateContent("Summarize the account history for \(anonId)")
    }

    private static func sha256(_ s: String) -> String { String(s.hashValue) }
}
