//
//  HardcodedSecrets.swift
//  CacomiTestApp
//
//  Fixtures for SecretPatternRule and HighEntropyStringRule.
//  All values are FAKE and follow the public format of the provider.
//

import Foundation

enum HardcodedSecrets {

    // CACOMI-EXPECT[SecretPatternRule|high]: AWS Access Key ID
    static let awsAccessKeyId = "AKIAIOSFODNN7EXAMPLE"

    // CACOMI-EXPECT[SecretPatternRule|high]: AWS Secret Access Key
    static let awsSecretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    // CACOMI-EXPECT[SecretPatternRule|high]: Stripe live secret key
    static let stripeLive = "sk_live_51HxYzAbCdEfGhIjKlMnOpQrStUvWxYz0123456789"

    // CACOMI-EXPECT[SecretPatternRule|high]: Google API key
    static let googleApiKey = "AIzaSyDuFAKEcacomiGoogleApiKey1234567890abcd"

    // CACOMI-EXPECT[SecretPatternRule|high]: GitHub personal access token
    static let githubToken = "ghp_FAKEcacomi1234567890abcdefghijklmnopqr12"

    // CACOMI-EXPECT[SecretPatternRule|high]: Slack bot token
    static let slackBot = "xoxb-1111111111-2222222222-FAKEcacomiSlackBotToken123"

    // CACOMI-EXPECT[SecretPatternRule|critical]: RSA private key embedded in source
    static let rsaPrivateKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAfakeCacomiRsaPrivateKeyBody1234567890abcdefghij
    klmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=fakeData
    -----END RSA PRIVATE KEY-----
    """

    // CACOMI-EXPECT[SecretPatternRule|high]: Hardcoded JWT (3 segments)
    static let hardcodedJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIn0.FAKEcacomiSignaturePart"

    // CACOMI-EXPECT[SecretPatternRule|high]: DB connection string with credentials
    static let dbConnectionString = "postgres://app_user:P@ssw0rd!2024@db.fake-cacomi.com:5432/appdb"

    // CACOMI-EXPECT[HighEntropyStringRule|medium]: high-entropy base64 blob (~40 chars)
    static let highEntropyBlob = "aZ9q+P3sL2vK1nM7oR8tU0yX5cD6gH4jK8lQwErT"

    // CACOMI-NEGATIVE[SecretPatternRule]: plain UUID is not a secret
    static let publicRequestId = "550e8400-e29b-41d4-a716-446655440000"

    // CACOMI-NEGATIVE[SecretPatternRule]: public git commit SHA is not a secret
    static let buildCommit = "9f8c2a17b3d4e5f60718293a4b5c6d7e8f9012ab"

    static func referenceAll() {
        _ = (awsAccessKeyId, awsSecretKey, stripeLive, googleApiKey,
             githubToken, slackBot, rsaPrivateKey, hardcodedJWT,
             dbConnectionString, highEntropyBlob,
             publicRequestId, buildCommit)
    }
}
