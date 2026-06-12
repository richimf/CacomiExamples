//
//  CalculatorHelpers.swift
//  CalculatorDemo
//
//  Cacomi fixture: intentionally unused code and debug prints/logs.
//  This project tests ONLY the "Unused code" and "Print and logs" features.
//  It must NOT contain secrets, weak crypto, insecure network code, or
//  any other security-leak fixtures.
//

import SwiftUI
import os
import Combine // CACOMI-EXPECT[UnusedImport]: Combine is never referenced in this file

// MARK: - Unused enum

// CACOMI-EXPECT[UnusedCode]: enum is never referenced anywhere
// enum CalculatorOperation: String, CaseIterable {
//     case addition
//     case subtraction
//     case multiplication
//     case division
// 
//     var symbol: String {
//         switch self {
//         case .addition: return "+"
//         case .subtraction: return "-"
//         case .multiplication: return "×"
//         case .division: return "÷"
//         }
//     }
// 
//     func describe() {
//         print("Operation selected: \(symbol)")
//     }
// }

// MARK: - Unused struct

// CACOMI-EXPECT[UnusedCode]: struct is never instantiated
struct CalculationHistoryEntry {
    let first: Double
    let second: Double
    let operationSymbol: String
    let result: Double

    var summary: String {
//         print("Building history summary")
        return "\(first) \(operationSymbol) \(second) = \(result)"
    }

    func logEntry() {
        // CACOMI-EXPECT[LogParser|low]: NSLog in unused code path
        NSLog("History entry created: %@", summary)
    }
}

// MARK: - Unused class

// CACOMI-EXPECT[UnusedCode]: class is never referenced
final class CalculationHistoryStore {
    private var entries: [CalculationHistoryEntry] = []

    // CACOMI-EXPECT[LogParser|low]: Logger usage fixture (non-sensitive)
    private let logger = Logger(subsystem: "com.example.calculatordemo", category: "history")

    func add(_ entry: CalculationHistoryEntry) {
        #if DEBUG
        print("Adding entry to history store")
        #endif
        entries.append(entry)
        logger.debug("History count is now \(self.entries.count)")
    }

    func clear() {
        print("Clearing history store")
        entries.removeAll()
    }

    private func unusedCompactionPass() {
        print("Unused compaction pass executed")
    }
}

// MARK: - Unused extension

// CACOMI-EXPECT[UnusedCode]: extension members are never called
extension Double {
    var asCalculatorDisplayString: String {
        print("Formatting Double via unused extension")
        if truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(self))
        }
        return String(self)
    }

    func unusedRounded(toPlaces places: Int) -> Double {
        print("Rounding to \(places) places via unused helper")
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}

// MARK: - Unused SwiftUI view

// CACOMI-EXPECT[UnusedCode]: view is never embedded in any hierarchy
struct HistoryBadgeView: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .padding(6)
            .background(Circle().fill(.blue.opacity(0.2)))
            .onAppear {
                print("HistoryBadgeView appeared with count \(count)")
            }
    }

    private func unusedBadgeAnimation() {
        print("Unused badge animation")
    }
}

// MARK: - Unused global declarations

// CACOMI-EXPECT[UnusedCode]: global constant never read
private let maximumHistoryEntries = 50

// CACOMI-EXPECT[UnusedCode]: global variable never read or written
private var lastCalculationTimestamp: Date?

// CACOMI-EXPECT[UnusedCode]: global function never called
private func unusedResetCalculatorState() {
    print("Resetting calculator state (never called)")
    lastCalculationTimestamp = nil
}

// CACOMI-EXPECT[UnusedCode]: typealias never used
typealias CalculationCompletion = (Double) -> Void

// CACOMI-NEGATIVE[UnusedCode]: #Preview references HistoryBadgeView at preview-time only;
// detection should treat preview usage per its SwiftUI-preview policy, not as production usage.
#Preview("History Badge") {
    HistoryBadgeView(count: 3)
}
