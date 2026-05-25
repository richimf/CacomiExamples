//
//  CacomiStressTest.swift
//  SampleProject
//
//  Created for unused-code and debug-log detection testing.
//

import SwiftUI
import SwiftData
import Combine
import Foundation
import UIKit
import CoreLocation // Potentially unused import
import AVFoundation // Potentially unused import

// MARK: - SwiftData Model

@Model
final class ExpenseRecord {
    var id: UUID
    var title: String
    var amount: Decimal
    var date: Date
    var category: String
    var notes: String?

    init(
        id: UUID = UUID(),
        title: String,
        amount: Decimal,
        date: Date = .now,
        category: String,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.notes = notes
    }

    var formattedAmount: String {
        print("Formatting amount for \(title)")
        return "\(amount)"
    }

    var unusedComputedSummary: String {
        "Unused summary for \(title)"
    }

    func markAsReviewed() {
        print("Expense reviewed:", title)
    }

    func unusedModelHelper() {
        print("This SwiftData model helper is never called")
    }
}

// MARK: - App State

@Observable
final class DashboardState {
    var searchText = ""
    var isLoading = false
    var selectedCategory: String?
    var expenses: [ExpenseRecord] = []

    @ObservationIgnored
    private var internalCache: [UUID: ExpenseRecord] = [:]

    func loadInitialData() async {
        print("DashboardState.loadInitialData started")
        isLoading = true

        defer {
            isLoading = false
            print("DashboardState.loadInitialData finished")
        }

        try? await Task.sleep(nanoseconds: 200_000_000)

        expenses = [
            ExpenseRecord(title: "Coffee", amount: 5.50, category: "Food"),
            ExpenseRecord(title: "Taxi", amount: 18.00, category: "Transport")
        ]

        print("Loaded expenses count:", expenses.count)
    }

    func filteredExpenses() -> [ExpenseRecord] {
        if searchText.isEmpty {
            return expenses
        }

        return expenses.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func rebuildCache() {
        print("Rebuilding cache")
        internalCache = Dictionary(uniqueKeysWithValues: expenses.map { ($0.id, $0) })
    }

    private func unusedPrivateStateReset() {
        print("This private reset is never called")
        searchText = ""
        selectedCategory = nil
    }

    func unusedPublicLookingMethod() {
        print("This method is internal by default and never called")
    }
}

// MARK: - Combine ViewModel

final class LegacyExpenseViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var results: [ExpenseRecord] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        print("LegacyExpenseViewModel init")

        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                print("Search query changed:", newValue)
                self?.performSearch(newValue)
            }
            .store(in: &cancellables)
    }

    private func performSearch(_ text: String) {
        print("Perform search:", text)

        if text.isEmpty {
            results = []
        }
    }

    private func unusedCombineHelper() {
        print("Unused combine helper")
    }
}

// MARK: - SwiftUI View

struct ExpenseDashboardView: View {
    @State private var state = DashboardState()
    @StateObject private var legacyViewModel = LegacyExpenseViewModel()

    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase

    @Query(sort: \ExpenseRecord.date, order: .reverse)
    private var storedExpenses: [ExpenseRecord]

    @State private var isShowingAddExpense = false
    @State private var selectedExpense: ExpenseRecord?
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                searchHeader

                List {
                    Section("Stored Expenses") {
                        ForEach(storedExpenses) { expense in
                            ExpenseRowView(expense: expense)
                                .onTapGesture {
                                    selectedExpense = expense
                                    print("Selected expense:", expense.title)
                                }
                        }
                    }

                    Section("Filtered Expenses") {
                        ForEach(state.filteredExpenses()) { expense in
                            ExpenseRowView(expense: expense)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        print("Add expense tapped")
                        isShowingAddExpense = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddExpense) {
                AddExpenseView { title, amount in
                    addExpense(title: title, amount: amount)
                }
            }
            .task {
                await state.loadInitialData()
            }
            .onChange(of: scenePhase) { _, newPhase in
                print("Scene phase changed:", String(describing: newPhase))
            }
        }
    }

    private var searchHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search")
                .font(.headline)

            TextField("Search expenses", text: $state.searchText)
                .textFieldStyle(.roundedBorder)
                .focused($isSearchFocused)

            Button("Focus Search") {
                print("Focus search button tapped")
                isSearchFocused = true
            }
        }
    }

    private func addExpense(title: String, amount: Decimal) {
        print("Adding expense:", title, amount)

        let expense = ExpenseRecord(
            title: title,
            amount: amount,
            category: "Manual"
        )

        modelContext.insert(expense)
        state.expenses.append(expense)

        #if DEBUG
        print("Inserted expense into SwiftData")
        debugPrint(expense)
        #endif
    }

    private func unusedDashboardHelper() {
        print("Unused dashboard helper")
    }

    private var unusedDashboardTitle: String {
        print("Unused computed title")
        return "Unused Dashboard Title"
    }
}

// MARK: - SwiftUI Subviews

struct ExpenseRowView: View {
    let expense: ExpenseRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)

                Text(expense.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(expense.formattedAmount)
                .font(.body.monospacedDigit())
        }
        .contextMenu {
            Button("Review") {
                print("Review selected:", expense.title)
                expense.markAsReviewed()
            }
        }
    }

    private func unusedRowAnimation() {
        print("Unused row animation")
    }
}

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var amountText = ""

    let onSave: (String, Decimal) -> Void

    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Amount", text: $amountText)

            Button("Save") {
                print("Save tapped with title:", title)
                save()
            }
            .disabled(title.isEmpty || amountText.isEmpty)
        }
        .padding()
    }

    private func save() {
        guard let doubleValue = Double(amountText) else {
            print("Invalid amount:", amountText)
            return
        }

        onSave(title, Decimal(doubleValue))
        dismiss()
    }

    private func unusedValidationHelper() -> Bool {
        print("Unused validation helper")
        return title.count > 3
    }
}

// MARK: - UIKit Example

final class ExpenseHostingViewController: UIViewController {
    private let state = DashboardState()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ExpenseHostingViewController viewDidLoad")

        let hostingController = UIHostingController(rootView: ExpenseDashboardView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ExpenseHostingViewController viewWillAppear")
    }

    @objc private func didTapLegacyButton() {
        print("Legacy button tapped")
    }

    private func configureUnusedLegacyButton() {
        let button = UIButton(type: .system)
        button.setTitle("Legacy", for: .normal)
        button.addTarget(self, action: #selector(didTapLegacyButton), for: .touchUpInside)
    }

    private func unusedUIKitHelper() {
        print("Unused UIKit helper")
    }
}

// MARK: - App Intent-like Example

#if canImport(AppIntents)
import AppIntents

struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Expense"
    static var openAppWhenRun = true

    @Parameter(title: "Title")
    var title: String

    @Parameter(title: "Amount")
    var amount: Double

    func perform() async throws -> some IntentResult {
        print("AppIntent perform called:", title, amount)
        return .result()
    }

    private func unusedIntentHelper() {
        print("Unused intent helper")
    }
}
#endif

// MARK: - Widget-like Example

#if canImport(WidgetKit)
import WidgetKit

struct ExpenseWidgetEntry: TimelineEntry {
    let date: Date
    let title: String
    let amount: String
}

struct ExpenseTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ExpenseWidgetEntry {
        print("Widget placeholder")
        return ExpenseWidgetEntry(date: .now, title: "Coffee", amount: "$5.50")
    }

    func getSnapshot(in context: Context, completion: @escaping (ExpenseWidgetEntry) -> Void) {
        print("Widget snapshot")
        completion(ExpenseWidgetEntry(date: .now, title: "Taxi", amount: "$18.00"))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ExpenseWidgetEntry>) -> Void) {
        print("Widget timeline")

        let entry = ExpenseWidgetEntry(date: .now, title: "Lunch", amount: "$12.00")
        completion(Timeline(entries: [entry], policy: .atEnd))
    }

    private func unusedProviderHelper() {
        print("Unused widget provider helper")
    }
}

struct ExpenseWidgetView: View {
    let entry: ExpenseWidgetEntry

    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.amount)
        }
    }
}

struct ExpenseWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "expense_widget",
            provider: ExpenseTimelineProvider()
        ) { entry in
            ExpenseWidgetView(entry: entry)
        }
        .configurationDisplayName("Expense Widget")
        .description("Shows a recent expense.")
    }
}
#endif

// MARK: - Concurrency Example

actor ExpenseSyncActor {
    private var pendingIDs: [UUID] = []

    func enqueue(_ id: UUID) {
        print("Enqueue sync:", id)
        pendingIDs.append(id)
    }

    func syncAll() async {
        print("Sync all started")

        await withTaskGroup(of: Void.self) { group in
            for id in pendingIDs {
                group.addTask {
                    print("Syncing ID:", id)
                    await Self.upload(id)
                }
            }
        }

        print("Sync all finished")
    }

    private static func upload(_ id: UUID) async {
        print("Uploading:", id)
    }

    private func unusedActorCleanup() {
        print("Unused actor cleanup")
        pendingIDs.removeAll()
    }
}

final class ExpenseSyncService {
    private let actor = ExpenseSyncActor()

    func startSync(for id: UUID) {
        print("Start sync requested:", id)

        Task {
            await actor.enqueue(id)
            await actor.syncAll()
        }
    }

    private func unusedSyncRetry() {
        print("Unused sync retry")
    }
}

// MARK: - Protocols and Extensions

protocol ExpenseExporting {
    func export(_ expenses: [ExpenseRecord]) throws -> Data
}

struct CSVExpenseExporter: ExpenseExporting {
    func export(_ expenses: [ExpenseRecord]) throws -> Data {
        print("Exporting CSV:", expenses.count)

        let rows = expenses.map {
            "\($0.title),\($0.amount),\($0.category)"
        }

        return rows.joined(separator: "\n").data(using: .utf8) ?? Data()
    }

    private func unusedCSVHeader() -> String {
        print("Unused CSV header")
        return "title,amount,category"
    }
}

struct JSONExpenseExporter: ExpenseExporting {
    func export(_ expenses: [ExpenseRecord]) throws -> Data {
        print("Exporting JSON:", expenses.count)
        return try JSONEncoder().encode(expenses.map { ExportExpenseDTO(from: $0) })
    }

    private func unusedJSONFormattingOption() -> JSONEncoder.OutputFormatting {
        print("Unused JSON formatting option")
        return .prettyPrinted
    }
}

struct ExportExpenseDTO: Codable {
    let title: String
    let amount: String
    let category: String

    init(from expense: ExpenseRecord) {
        print("Creating DTO from:", expense.title)
        title = expense.title
        amount = "\(expense.amount)"
        category = expense.category
    }

    private var unusedDTODescription: String {
//         print("Unused DTO description")
        return "\(title) - \(amount)"
    }
}

extension Array where Element == ExpenseRecord {
    var totalAmount: Decimal {
//         print("Calculating total amount")
        return reduce(Decimal.zero) { partialResult, expense in
            partialResult + expense.amount
        }
    }

    func groupedByCategory() -> [String: [ExpenseRecord]] {
//         print("Grouping by category")
        return Dictionary(grouping: self, by: { $0.category })
    }

    func unusedSortedByTitle() -> [ExpenseRecord] {
//         print("Unused sorted by title")
        return sorted { $0.title < $1.title }
    }
}

// MARK: - Enums

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case food
    case transport
    case entertainment
    case health
    case unusedLegacyCategory

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .food:
            return "Food"
        case .transport:
            return "Transport"
        case .entertainment:
            return "Entertainment"
        case .health:
            return "Health"
        case .unusedLegacyCategory:
            return "Legacy"
        }
    }

    var iconName: String {
        switch self {
        case .food:
            return "fork.knife"
        case .transport:
            return "car"
        case .entertainment:
            return "film"
        case .health:
            return "cross"
        case .unusedLegacyCategory:
            return "archivebox"
        }
    }

    private func unusedCategoryHelper() {
//         print("Unused category helper")
    }
}

// MARK: - Conditional Compilation

// #if DEBUG
// struct DebugExpenseInspector {
//     func inspect(_ expense: ExpenseRecord) {
//         print("DEBUG Inspecting expense:", expense.title)
//         debugPrint(expense)
//     }
// 
//     func unusedDebugOnlyTool() {
//         print("Unused debug-only tool")
//     }
// }
// #endif

#if os(iOS)
final class IOSOnlyExpenseTool {
    func run() {
        print("Running iOS-only expense tool")
    }

    private func unusedIOSOnlyHelper() {
        print("Unused iOS-only helper")
    }
}
#endif

#if os(macOS)
final class MacOnlyExpenseTool {
    func run() {
        print("Running macOS-only expense tool")
    }

    private func unusedMacOnlyHelper() {
        print("Unused macOS-only helper")
    }
}
#endif

// MARK: - Clearly Unused Code

final class CompletelyUnusedReportBuilder {
    private var title = "Unused Report"

    func build() -> String {
        print("Building unused report")
        return title
    }

    private func calculateUnusedMetrics() -> [String: Int] {
        print("Calculating unused metrics")
        return ["unused": 1]
    }
}

struct UnusedStandaloneView: View {
    var body: some View {
        VStack {
            Text("Unused Standalone View")
            Button("Tap") {
                print("Unused standalone button tapped")
            }
        }
    }

    private func unusedStandaloneHelper() {
        print("Unused standalone helper")
    }
}

private func unusedGlobalHelper() {
    print("Unused global helper")
}

private let unusedGlobalConstant = "This global constant is never used"

func usedGlobalBootstrap() {
    print("Used global bootstrap")

    let service = ExpenseSyncService()
    service.startSync(for: UUID())

    let exporter = CSVExpenseExporter()
    let expenses = [
        ExpenseRecord(title: "Dinner", amount: 25, category: "Food")
    ]

    do {
        _ = try exporter.export(expenses)
    } catch {
        print("Export failed:", error)
    }
}