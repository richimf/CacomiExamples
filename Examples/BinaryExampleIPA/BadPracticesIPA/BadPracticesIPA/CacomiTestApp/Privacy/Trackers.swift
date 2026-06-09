//
//  Trackers.swift
//  CacomiTestApp
//
//  Fixtures for TrackerDetectionRule.
//  Real SDKs are not linked; this file references their module names so
//  static import-based detectors can still match.
//

import Foundation

// CACOMI-EXPECT[TrackerDetectionRule|medium]: Facebook/Meta SDK detected
#if canImport(FBSDKCoreKit)
import FBSDKCoreKit
#endif

// CACOMI-EXPECT[TrackerDetectionRule|medium]: Firebase Analytics detected
#if canImport(FirebaseAnalytics)
import FirebaseAnalytics
#endif

// CACOMI-EXPECT[TrackerDetectionRule|medium]: Amplitude SDK detected
#if canImport(Amplitude)
import Amplitude
#endif

// CACOMI-EXPECT[TrackerDetectionRule|medium]: Adjust SDK detected
#if canImport(AdjustSdk)
import AdjustSdk
#endif

// CACOMI-EXPECT[TrackerDetectionRule|medium]: AppsFlyer SDK detected
#if canImport(AppsFlyerLib)
import AppsFlyerLib
#endif

enum TrackerStrings {
    // CACOMI-EXPECT[TrackerDetectionRule|low]: tracker endpoint URL
    static let metaPixel = "https://graph.facebook.com/v17.0/123456789/activities"
    // CACOMI-EXPECT[TrackerDetectionRule|low]: AppsFlyer endpoint URL
    static let appsFlyer = "https://events.appsflyer.com/api/v6.0/androidevent"
}
