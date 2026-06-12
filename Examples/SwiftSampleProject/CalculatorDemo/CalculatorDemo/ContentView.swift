//
//  ContentView.swift
//  BasicCalculator
//

import SwiftUI

struct ContentView: View {
    @State private var firstNumber: String = ""
    @State private var secondNumber: String = ""
    @State private var result: String = "0"

    // CACOMI-EXPECT[UnusedCode]: @State property never read or written
    @State private var unusedHistoryVisible: Bool = false

    // CACOMI-EXPECT[UnusedCode]: constant never read
    private let unusedDecimalPlaces = 2

    // CACOMI-EXPECT[UnusedCode]: computed property never accessed
    private var unusedScreenTitle: String {
        print("Computing unused screen title")
        return "Basic Calculator (unused title)"
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Basic Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                TextField("First number", text: $firstNumber)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)

                TextField("Second number", text: $secondNumber)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(spacing: 12) {
                Button {
//                     print("Add button tapped")
                    addNumbers()
                } label: {
                    Text("Add")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
//                     print("Subtract button tapped")
                    subtractNumbers()
                } label: {
                    Text("Subtract")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            VStack(spacing: 8) {
                Text("Result")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(result)
                    .font(.system(size: 36, weight: .bold))
            }

            Spacer()
        }
        .padding()
        .onAppear {
//             print("ContentView appeared")
//             print("Initial firstNumber: \(firstNumber)")
//             print("Initial secondNumber: \(secondNumber)")
//             print("Initial result: \(result)")
        }
    }

    private func addNumbers() {
        #if DEBUG
        print("addNumbers() started")
        print("Raw firstNumber input: \(firstNumber)")
        print("Raw secondNumber input: \(secondNumber)")
        #endif

        guard let firstValue = Double(firstNumber) else {
            #if DEBUG
            print("Failed to convert firstNumber to Double")
            #endif
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("firstNumber converted successfully: \(firstValue)")

        guard let secondValue = Double(secondNumber) else {
            print("Failed to convert secondNumber to Double")
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("secondNumber converted successfully: \(secondValue)")

        let total = firstValue + secondValue
        print("Addition result before formatting: \(total)")

        result = formatResult(total)
        print("Formatted addition result: \(result)")
        print("addNumbers() finished")
    }

    private func subtractNumbers() {
        print("subtractNumbers() started")
        print("Raw firstNumber input: \(firstNumber)")
        print("Raw secondNumber input: \(secondNumber)")

        guard let firstValue = Double(firstNumber) else {
            print("Failed to convert firstNumber to Double")
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("firstNumber converted successfully: \(firstValue)")

        guard let secondValue = Double(secondNumber) else {
            print("Failed to convert secondNumber to Double")
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("secondNumber converted successfully: \(secondValue)")

        let total = firstValue - secondValue
        print("Subtraction result before formatting: \(total)")

        result = formatResult(total)
        print("Formatted subtraction result: \(result)")
        print("subtractNumbers() finished")
    }

    // Declared but not used
//     private func multiplyNumbers() {
//         print("multiplyNumbers() started")
//         print("Raw firstNumber input: \(firstNumber)")
//         print("Raw secondNumber input: \(secondNumber)")
// 
//         guard let firstValue = Double(firstNumber) else {
//             print("Failed to convert firstNumber to Double")
//             result = "Invalid input"
//             print("Result updated to: \(result)")
//             return
//         }
// 
//         print("firstNumber converted successfully: \(firstValue)")
// 
//         guard let secondValue = Double(secondNumber) else {
//             print("Failed to convert secondNumber to Double")
//             result = "Invalid input"
//             print("Result updated to: \(result)")
//             return
//         }
// 
//         print("secondNumber converted successfully: \(secondValue)")
// 
//         let total = firstValue * secondValue
//         print("Multiplication result before formatting: \(total)")
// 
//         result = formatResult(total)
//         print("Formatted multiplication result: \(result)")
//         print("multiplyNumbers() finished")
//     }

    // Declared but not used
    private func divideNumbers() {
        print("divideNumbers() started")
        print("Raw firstNumber input: \(firstNumber)")
        print("Raw secondNumber input: \(secondNumber)")

        guard let firstValue = Double(firstNumber) else {
            print("Failed to convert firstNumber to Double")
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("firstNumber converted successfully: \(firstValue)")

        guard let secondValue = Double(secondNumber) else {
            print("Failed to convert secondNumber to Double")
            result = "Invalid input"
            print("Result updated to: \(result)")
            return
        }

        print("secondNumber converted successfully: \(secondValue)")

        guard secondValue != 0 else {
            print("Division stopped because secondValue is zero")
            result = "Cannot divide by zero"
            print("Result updated to: \(result)")
            return
        }

        let total = firstValue / secondValue
        print("Division result before formatting: \(total)")

        result = formatResult(total)
        print("Formatted division result: \(result)")
        print("divideNumbers() finished")
    }

    private func formatResult(_ value: Double) -> String {
        print("formatResult() started")
        print("Value received: \(value)")

        if value.truncatingRemainder(dividingBy: 1) == 0 {
            print("Value has no decimal part")
            let formattedValue = String(Int(value))
            print("Formatted value: \(formattedValue)")
            print("formatResult() finished")
            return formattedValue
        } else {
            print("Value has decimal part")
            let formattedValue = String(value)
            print("Formatted value: \(formattedValue)")
            print("formatResult() finished")
            return formattedValue
        }
    }
}

#Preview {
    ContentView()
}
