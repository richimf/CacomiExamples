//
//  UnusedCodeCacomi.swift
//  BadPracticesIPA
//
//  Cacomi fixture: UnusedCode positives + dynamic-use negatives.
//

import Foundation
import UIKit
import SwiftUI

// BAD: import not used                                  // CACOMI-EXPECT: UnusedCode
import CoreImage

// BAD: private function never called                    // CACOMI-EXPECT: UnusedCode
private func cacomi_unusedHelper() -> Int { 7 }

// BAD: class never instantiated                         // CACOMI-EXPECT: UnusedCode
final class CacomiUnusedClass {
    func work() {}
}

// BAD: struct never referenced                          // CACOMI-EXPECT: UnusedCode
struct CacomiUnusedStruct { let id: Int }

// BAD: enum never referenced                            // CACOMI-EXPECT: UnusedCode
enum CacomiUnusedEnum { case red, green }

// BAD: extension method never called                    // CACOMI-EXPECT: UnusedCode
extension String {
    func cacomi_unusedMethod() -> String { self + "!" }
}

enum CacomiUnusedHolder {
    // BAD: private constant never read                  // CACOMI-EXPECT: UnusedCode
    private static let unreadConst = 42
    // BAD: private property never read                  // CACOMI-EXPECT: UnusedCode
    private static var unreadVar: Int = 0
}

// MARK: - Dynamic-use negatives (must NOT be flagged)

// GOOD: SwiftUI app entry point alive via @main          // CACOMI-EXPECT: none
@available(iOS 14, *)
struct CacomiDummyEntry: View { var body: some View { Text("hi") } }

#Preview {
    // GOOD: SwiftUI #Preview is a design-time consumer   // CACOMI-EXPECT: none
    CacomiDummyEntry()
}

// GOOD: AppDelegate method invoked by UIApplication      // CACOMI-EXPECT: none
final class CacomiAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool { true }
}

final class CacomiVC: UIViewController {

    // GOOD: @IBOutlet wired in Storyboard/XIB             // CACOMI-EXPECT: none
    @IBOutlet weak var titleLabel: UILabel?

    // GOOD: @IBAction invoked by Interface Builder        // CACOMI-EXPECT: none
    @IBAction func didTap(_ sender: Any) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIButton(type: .system)
        // GOOD: registered via #selector at runtime       // CACOMI-EXPECT: none
        b.addTarget(self, action: #selector(handleSelectorCall), for: .touchUpInside)
    }

    // GOOD: callable through Obj-C runtime selectors      // CACOMI-EXPECT: none
    @objc dynamic func handleSelectorCall() {}
}

// GOOD: Codable referenced by JSONDecoder via reflection // CACOMI-EXPECT: none
struct CacomiAccountDTO: Codable {
    let id: Int
    let name: String
}

// GOOD: symbol only used from @testable test target       // CACOMI-EXPECT: none
public final class CacomiTestableInternals {
    public init() {}
    public func resetForTests() {}
}
