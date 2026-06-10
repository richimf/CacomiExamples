//
// SwiftUISecurityAndUnusedFixture.swift
//
// Purpose:
// This SwiftUI fixture intentionally contains:
// - SwiftUI views, modifiers, property wrappers, async actions, and previews
// - Explicit unused code named with "unused_*"
// - Hardcoded secrets
// - Sensitive logs
// - HTTP URLs
// - Weak crypto
// - UserDefaults and @AppStorage sensitive storage
// - SSL bypass patterns
// - Debug/test code risks
//
// This file is intentionally unsafe and should only be used to test Cacomi.
//

import SwiftUI
import Foundation
import CryptoKit
import CommonCrypto
import os.log

struct SwiftUISecurityAndUnusedFixtureView: View {
    @StateObject private var viewModel = SwiftUISecurityAndUnusedViewModel()
    @State private var email = ""
    @State private var password = ""

    @AppStorage("accessToken") private var accessToken = ""
    @AppStorage("refreshToken") private var refreshToken = ""
    @AppStorage("jwt") private var jwt = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Credentials") {
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)

                    Button("Login") {
                        viewModel.login(email: email, password: password)
                    }

                    Button("Load AI Recommendations") {
                        Task {
                            await viewModel.loadAIRecommendations()
                        }
                    }
                }

                Section("Status") {
                    Text(viewModel.status)
                    Text("Insecure endpoint: \(viewModel.insecureEndpoint)")
                }
            }
            .navigationTitle("SwiftUI Fixture")
            .onAppear {
                viewModel.configure()
            }
        }
    }
}

@MainActor
final class SwiftUISecurityAndUnusedViewModel: ObservableObject {
    @Published var status = "Idle"

    let insecureEndpoint = "http://api.example.com/swiftui"
    private let apiKey = "sk_live_swiftui_1234567890"
    private let token = "Bearer swiftui-hardcoded-token"
    private let password = "SwiftUIPassword123"
    private let jwt = "eyJhbGciOiJIUzI1NiJ9.swiftui.payload.signature"

    private let bypassLogin = true
    private let isAdmin = true
    private let disableSSLValidation = true

    func configure() {
        print("API key: \(apiKey)")
        debugPrint("Token: \(token)")
        NSLog("Password: %@", password)
        os_log("JWT: %@", jwt)

        UserDefaults.standard.set(token, forKey: "accessToken")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(jwt, forKey: "jwt")

        status = "Configured"
    }

    func login(email: String, password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
        print("Authorization: \(token)")

        if bypassLogin {
            print("Bypass login enabled")
        }

        if isAdmin {
            print("Admin mode enabled")
        }

        if disableSSLValidation {
            print("SSL validation disabled")
        }
    }

    func loadAIRecommendations() async {
        print("Loading from http://ai.example.com/recommendations")
        try? await Task.sleep(nanoseconds: 5_000_000)
        status = "Loaded"
    }

    func weakCrypto() {
        let data = Data("secret".utf8)
        let md5 = Insecure.MD5.hash(data: data)
        let sha1 = Insecure.SHA1.hash(data: data)
        print("MD5: \(md5)")
        print("SHA1: \(sha1)")
    }

    func unused_function() {
        print("unused_function token: \(token)")
    }

    private func unused_storeSecret() {
        UserDefaults.standard.set("unused-secret", forKey: "unusedToken")
    }

    private var unused_computedProperty: String {
        print("unused computed password: \(password)")
        return password
    }
}

struct unused_swiftui_view: View {
    let unused_secret = "unused-swiftui-view-secret"

    var body: some View {
        VStack {
            Text("Unused SwiftUI View")
            Button("Unused") {
                print("unused_secret: \(unused_secret)")
            }
        }
    }
}

extension SwiftUISecurityAndUnusedViewModel {
    func unused_extension_function() {
        print("unused extension token: \(token)")
    }
}

// ============================================================================
// P1 parity additions (new patterns) — all values are FAKE / for testing only
// ============================================================================

enum SwiftUIP1Secrets {
    // CACOMI-EXPECT[SecretPatternRule|high]: Azure AD client secret
    static let azure = "Qj8Q~aB3cDeFgHiJkLmNoPqRsTuVwXyZ012345"
    // CACOMI-EXPECT[SecretPatternRule|high]: Supabase project URL
    static let supabase = "https://abcdefghijklmnopqrst.supabase.co"
    // CACOMI-EXPECT[SecretPatternRule|high]: GitLab runner token
    static let gitlabRunner = "glrt-AbCdEfGhIjKlMnOpQrS1"
    // CACOMI-EXPECT[SecretPatternRule|high]: SMTP credentials in URL
    static let smtp = "smtp://mailer:Pa55w0rdMailer@smtp.example.com:587"
    // CACOMI-EXPECT[SecretPatternRule|high]: OAuth implicit flow
    static let oauthImplicit = "https://idp.example.com/authorize?client_id=app&response_type=token"
    // CACOMI-NEGATIVE[SecretPatternRule]: PKCE auth code flow (secure form)
    static let oauthSecure = "https://idp.example.com/authorize?response_type=code&code_challenge=xyz"
}

enum SwiftUIP1Misc {
    // CACOMI-EXPECT[InjectionRules|high]: NSPredicate format-string injection
    static func find(_ userInput: String) -> NSPredicate {
        NSPredicate(format: "name == \(userInput) AND active == 1")
    }
    // CACOMI-NEGATIVE[InjectionRules]: parameterised predicate
    static func findSafe(_ userInput: String) -> NSPredicate {
        NSPredicate(format: "name == %@ AND active == 1", userInput)
    }
    // CACOMI-EXPECT[WeakCipherRule|high]: AES-ECB mode option
    static let ecbMode = kCCOptionECBMode
    // CACOMI-EXPECT[InsecureStorageRule|high]: file written with data protection disabled
    static func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: [.noFileProtection])
    }
    // CACOMI-EXPECT[LogParser|medium]: conditional-wrapped password log
    static func conditionalLog(_ password: String) {
        if ProcessInfo.processInfo.environment["DBG"] != nil { print("password=\(password)") }
    }
}

#Preview {
    SwiftUISecurityAndUnusedFixtureView()
}
