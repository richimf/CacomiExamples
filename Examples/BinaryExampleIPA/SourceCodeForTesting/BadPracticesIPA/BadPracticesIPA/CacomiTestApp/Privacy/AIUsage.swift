//
//  AIUsage.swift
//  CacomiTestApp
//
//  Fixtures for AIDiscoveryRule (CoreML, Vision, AI endpoints).
//

import Foundation
// CACOMI-EXPECT[AIDiscoveryRule|info]: CoreML imported
import CoreML
// CACOMI-EXPECT[AIDiscoveryRule|info]: Vision imported
import Vision

enum AIUsage {

    // CACOMI-EXPECT[AIDiscoveryRule|info]: bundled CoreML model reference
    static let modelFileName = "model.mlmodel"

    // CACOMI-EXPECT[AIDiscoveryRule|high]: OpenAI chat completions endpoint
    static let openAIChat = "https://api.openai.com/v1/chat/completions"

    // CACOMI-EXPECT[AIDiscoveryRule|high]: Anthropic messages endpoint
    static let anthropicMessages = "https://api.anthropic.com/v1/messages"

    static func loadModel() -> MLModel? {
        guard let url = Bundle.main.url(forResource: "model", withExtension: "mlmodelc") else {
            return nil
        }
        return try? MLModel(contentsOf: url)
    }

    static func visionRequest() -> VNCoreMLRequest? {
        guard let model = loadModel(),
              let vnModel = try? VNCoreMLModel(for: model) else { return nil }
        return VNCoreMLRequest(model: vnModel)
    }
}
