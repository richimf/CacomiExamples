//
//  PrivacyAndTrackersCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: TrackerDetection / AIDiscovery / OSV inventory.
//

import Foundation
// BAD: CoreML imported by app                              // CACOMI-EXPECT: AIDiscovery
import CoreML
// BAD: Vision imported by app                              // CACOMI-EXPECT: AIDiscovery
import Vision

enum PrivacyAndTrackersCacomi {

    // BAD: tracker SDK name embedded in string              // CACOMI-EXPECT: TrackerDetection
    static let metaPixelSDK = "FBSDKCoreKit"
    // BAD: tracker SDK name embedded in string              // CACOMI-EXPECT: TrackerDetection
    static let firebaseAnalytics = "FirebaseAnalytics"
    // BAD: tracker SDK name embedded in string              // CACOMI-EXPECT: TrackerDetection
    static let appsflyer = "AppsFlyerLib"
    // BAD: tracker SDK name embedded in string              // CACOMI-EXPECT: TrackerDetection
    static let adjust = "AdjustSdk"

    // BAD: tracker endpoint URL                             // CACOMI-EXPECT: TrackerDetection
    static let metaEvents = "https://graph.facebook.com/v17.0/123/activities"
    // BAD: AppsFlyer endpoint URL                           // CACOMI-EXPECT: TrackerDetection
    static let afEvents = "https://events.appsflyer.com/api/v6.0/androidevent"

    // BAD: OpenAI endpoint                                  // CACOMI-EXPECT: AIDiscovery
    static let openAIChat = "https://api.openai.com/v1/chat/completions"
    // BAD: Anthropic endpoint                               // CACOMI-EXPECT: AIDiscovery
    static let anthropicMsg = "https://api.anthropic.com/v1/messages"
    // BAD: bundled CoreML model name                        // CACOMI-EXPECT: AIDiscovery
    static let modelFile = "cacomi_dummy_model.mlmodel"

    static func callAIWithApiKey() {
        let url = URL(string: openAIChat)!
        var req = URLRequest(url: url)
        // BAD: outbound AI call with api_key header         // CACOMI-EXPECT: AIDiscovery
        req.setValue("Bearer sk-cacomi-dummy-openai-key", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req).resume()
    }

    // BAD: OSV-friendly inventory string (fake dependency)   // CACOMI-EXPECT: OSV
    static let pseudoDependencyManifest = """
    {
      "dependencies": {
        "cacomi-fake-lib": "1.0.0",
        "another-fake": "0.0.1"
      }
    }
    """
}
