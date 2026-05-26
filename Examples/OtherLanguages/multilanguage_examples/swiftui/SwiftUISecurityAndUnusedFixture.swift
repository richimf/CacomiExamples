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

#Preview {
    SwiftUISecurityAndUnusedFixtureView()
}
