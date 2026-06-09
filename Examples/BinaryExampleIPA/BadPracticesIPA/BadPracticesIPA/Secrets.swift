//
//  Secrets.swift
//  BadPracticesIPA
//
//  Created by Ricardo Montesinos on 02/06/26.
//
import Foundation

enum BadSecrets {
    // MARK: - Fake hardcoded API keys
    static let unused_api_key = "sk_test_FAKE_CACOMI_1234567890abcdef"
    static let unused_secret_key = "SECRET_FAKE_CACOMI_0987654321"
    static let unused_bearer_token = "Bearer FAKE_CACOMI_TOKEN_abcdefghijklmnopqrstuvwxyz"
    static let unused_firebase_key = "AIzaSyFAKE_CACOMI_TEST_KEY_123456789"
    static let unused_aws_access_key = "AKIAFAKECACOMI123456"
    static let unused_aws_secret = "FAKEwJalrXUtnFEMI/K7MDENG/bPxRfiCYFAKEKEY"
    static let unused_private_key = """
    -----BEGIN PRIVATE KEY-----
    FAKECACOMIKEY1234567890
    -----END PRIVATE KEY-----
    """

    // MARK: - Used values to force them into the binary

    static let productionApiURL = "https://api.fake-production-cacomi.com/v1"
    static let productionApiKey = "prod_FAKE_CACOMI_API_KEY_DO_NOT_USE"
    static let sentryDSN = "https://fakepublickey@o0.ingest.sentry.io/123456"

    // MARK: - More hardcoded credentials (third-party services)

    static let stripeSecretKey = "sk_live_FAKE_CACOMI_STRIPE_51HxYzAbCdEfGhIjKlMnOpQrStUvWxYz"
    static let stripePublishableKey = "pk_live_FAKE_CACOMI_STRIPE_PUBLISHABLE_ABCDEF123456"
    static let slackBotToken = "xoxb-FAKE-CACOMI-1234567890-0987654321-abcdefghijklmnopqrstuvwx"
    static let slackWebhookURL = "https://hooks.slack.com/services/T00000000/B00000000/FAKECACOMIWEBHOOKTOKEN123"
    static let githubPersonalAccessToken = "ghp_FAKECACOMI1234567890abcdefghijklmnop12"
    static let githubOAuthToken = "gho_FAKECACOMI0987654321zyxwvutsrqponmlkjih98"
    static let twilioAccountSid = "ACFAKECACOMI1234567890abcdef1234567890ab"
    static let twilioAuthToken = "FAKECACOMITWILIOAUTHTOKEN1234567890abcdef"
    static let sendgridApiKey = "SG.FAKECACOMI_sendgrid_key.abcdefghijklmnopqrstuvwxyz1234567890"
    static let mailgunApiKey = "key-FAKECACOMI1234567890abcdef1234567890"
    static let googleMapsApiKey = "AIzaSyFAKE_CACOMI_GOOGLE_MAPS_KEY_12345678"
    static let oneSignalAppId = "FAKE-CACOMI-APP-ID-1234-5678-9012-345678901234"
    static let oneSignalRestKey = "FAKECACOMIONESIGNALRESTKEY1234567890abcdefghijklmnopqrstuv"
    static let algoliaAdminKey = "FAKE_CACOMI_ALGOLIA_ADMIN_KEY_abcdef1234"
    static let mixpanelToken = "FAKECACOMIMIXPANELTOKEN1234567890abcdef"
    static let openAIApiKey = "sk-FAKE-CACOMI-OPENAI-abcdefghijklmnopqrstuvwxyz1234567890ABCD"
    static let anthropicApiKey = "sk-ant-api03-FAKE-CACOMI-anthropic-key-abcdefghijklmnopqrstuvwxyz1234567890"

    // Azure
    static let azureClientId = "11111111-2222-3333-4444-555555555555"
    static let azureClientSecret = "FAKE~cacomi.AzureClient.Secret_1234567890ABCDEFghijklmnop"
    static let azureStorageKey = "DefaultEndpointsProtocol=https;AccountName=cacomifake;AccountKey=FAKEcacomiAzureStorageKey1234567890abcdefghijklmnopqrstuvwxyz==;EndpointSuffix=core.windows.net"
    // Heroku
    static let herokuApiKey = "12345678-aaaa-bbbb-cccc-1234567890ab"
    // DigitalOcean
    static let digitalOceanToken = "dop_v1_FAKEcacomiDigitalOceanToken1234567890abcdef1234567890abcdef1234567890ab"
    // Cloudflare
    static let cloudflareApiToken = "FAKEcacomi-cloudflare-token-abcdef1234567890abcdef12345"
    // GitLab
    static let gitlabToken = "glpat-FAKEcacomi-gitlab-PAT-1234567890ab"
    // NPM
    static let npmAuthToken = "npm_FAKEcacomiNpmToken1234567890abcdefghij1234567890"
    // Discord
    static let discordBotToken = "MTAxMjM0NTY3ODkwMTIzNDU2.FAKEca.FAKEcacomiDiscordBotTokenXXXXXXXXXXXXXXXXX"
    // Telegram
    static let telegramBotToken = "1234567890:AAFAKEcacomiTelegramBotTokenABCDEFGHIJKLMN"
    // HuggingFace
    static let huggingFaceToken = "hf_FAKEcacomiHuggingFaceToken1234567890abcdefghij"
    // Square
    static let squareAccessToken = "sq0atp-FAKEcacomiSquareAccessToken1234"
    // PGP / GPG key marker
    static let pgpPrivateKey = """
    -----BEGIN PGP PRIVATE KEY BLOCK-----
    Version: GnuPG v2

    FAKECACOMIPGPPRIVATEKEYDATA1234567890abcdefghijklmnopqrstuvwxyz
    -----END PGP PRIVATE KEY BLOCK-----
    """
    // PKCS8 / EC private key markers
    static let ecPrivateKey = """
    -----BEGIN EC PRIVATE KEY-----
    FAKECACOMIECPRIVATEKEY1234567890abcdef
    -----END EC PRIVATE KEY-----
    """
    static let dsaPrivateKey = """
    -----BEGIN DSA PRIVATE KEY-----
    FAKECACOMIDSAPRIVATEKEY1234567890abcdef
    -----END DSA PRIVATE KEY-----
    """

    // MARK: - Database credentials (should NEVER be hardcoded)

    static let dbHost = "prod-db.fake-cacomi.com"
    static let dbPort = 5432
    static let dbUser = "admin"
    static let dbPassword = "SuperSecret123!FakeCacomi"
    static let dbConnectionString = "postgres://admin:SuperSecret123!FakeCacomi@prod-db.fake-cacomi.com:5432/production"
    static let redisURL = "redis://:RedisFakeCacomiPassword2024@cache.fake-cacomi.com:6379"
    static let mongoURI = "mongodb://root:MongoFakeCacomiRoot2024@mongo.fake-cacomi.com:27017/admin"

    // MARK: - JWT / OAuth secrets

    static let jwtSigningSecret = "fake-cacomi-jwt-hs256-secret-do-not-share-in-production-2024"
    static let oauthClientId = "fake-cacomi-oauth-client-id-123456789"
    static let oauthClientSecret = "fake-cacomi-oauth-client-secret-abcdefghijklmnopqrstuvwxyz"
    static let refreshToken = "rt_FAKE_CACOMI_refresh_token_persistent_abcdefghijklmnop"

    // MARK: - SSH / Crypto keys hardcoded

    static let sshPrivateKey = """
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
    FAKECACOMISSHPRIVATEKEYDONOTUSEINPRODUCTION1234567890abcdefghijklmno
    -----END OPENSSH PRIVATE KEY-----
    """

    static let rsaPrivateKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEAFAKECACOMIRSAKEY1234567890abcdefghijklmnopqrstuvwxyz
    -----END RSA PRIVATE KEY-----
    """

    // MARK: - Hardcoded credentials for "admin" backdoor (anti-pattern)

    static let backdoorUsername = "admin"
    static let backdoorPassword = "admin123"
    static let masterPin = "0000"

    static func buildUnsafeHeaders() -> [String: String] {
        [
            "Authorization": "Bearer \(productionApiKey)",
            "X-API-Key": productionApiKey,
            "X-Internal-Secret": "internal_secret_FAKE_CACOMI_123",
            "X-Stripe-Key": stripeSecretKey,
            "X-Slack-Token": slackBotToken,
            "X-Github-Token": githubPersonalAccessToken,
            "X-Twilio-Token": twilioAuthToken,
            "X-OpenAI-Key": openAIApiKey,
            "X-Admin-Pass": backdoorPassword
        ]
    }

    static func printBadLogs() {
        print("Login token: \(productionApiKey)")
        debugPrint("Authorization header:", buildUnsafeHeaders())
        NSLog("User password is: FAKE_PASSWORD_123456")
        print("DB connection: \(dbConnectionString)")
        print("JWT secret: \(jwtSigningSecret)")
        print("Stripe secret: \(stripeSecretKey)")
        print("Backdoor: \(backdoorUsername):\(backdoorPassword)")
        NSLog("Refresh token: %@", refreshToken)
    }
}
