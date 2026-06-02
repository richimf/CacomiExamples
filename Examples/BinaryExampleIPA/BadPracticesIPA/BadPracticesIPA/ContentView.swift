//
//  ContentView.swift
//  BadPracticesIPA
//
//  Created by Ricardo Montesinos on 02/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Bad Practices Fixture")
                .font(.title)

            Button("Trigger bad logs") {
                BadSecrets.printBadLogs()
                _ = BadSecrets.buildUnsafeHeaders()
            }
        }
        .padding()
        .onAppear {
            BadSecrets.printBadLogs()
            _ = BadSecrets.buildUnsafeHeaders()
        }
    }
}
#Preview {
    ContentView()
}
