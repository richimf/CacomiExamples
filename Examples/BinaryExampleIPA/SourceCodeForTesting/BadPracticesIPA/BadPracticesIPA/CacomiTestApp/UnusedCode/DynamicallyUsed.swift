//
//  DynamicallyUsed.swift
//  CacomiTestApp
//
//  Fixtures for unused-code detection (negative controls).
//  None of the symbols below should be flagged as "unused"
//  because they are wired up via runtime reflection, IB, SwiftUI
//  previews, Codable keys, #selector, or framework callbacks.
//

import Foundation
import UIKit
import SwiftUI

// CACOMI-NEGATIVE[UnusedCode]: @IBAction is invoked via Interface Builder
final class DynamicViewController: UIViewController {

    // CACOMI-NEGATIVE[UnusedCode]: @IBOutlet is wired in IB
    @IBOutlet weak var label: UILabel?

    @IBAction func didTapButton(_ sender: Any) {
        // wired in IB; no static caller
    }

    override func viewDidLoad() {
        // CACOMI-NEGATIVE[UnusedCode]: protocol method invoked by UIKit
        super.viewDidLoad()
        let btn = UIButton(type: .system)
        // CACOMI-NEGATIVE[UnusedCode]: method registered via #selector
        btn.addTarget(self, action: #selector(handleSelectorCall), for: .touchUpInside)
    }

    @objc func handleSelectorCall() {
        // CACOMI-NEGATIVE[UnusedCode]: invoked dynamically by UIKit through selector
    }
}

// CACOMI-NEGATIVE[UnusedCode]: SwiftUI #Preview keeps the view alive at design-time
struct PreviewableView: View {
    var body: some View { Text("hi") }
}
#Preview {
    PreviewableView()
}

// CACOMI-NEGATIVE[UnusedCode]: Codable type referenced by JSONDecoder via reflection
struct AccountDTO: Codable {
    let id: Int
    let name: String

    // CACOMI-NEGATIVE[UnusedCode]: CodingKeys used by Codable machinery via reflection
    enum CodingKeys: String, CodingKey {
        case id
        case name = "full_name"
    }
}

// CACOMI-NEGATIVE[UnusedCode]: AppDelegate method invoked by UIApplication at launch
final class TestAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
}
