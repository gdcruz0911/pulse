import Foundation

struct QuotaWindow: Identifiable {
    let id = UUID()
    let label: String
    let usedPercentage: Double
    let resetText: String
}

struct ProviderUsage: Identifiable {
    let id: String
    let name: String
    let planTier: String
    let iconName: String
    let updatedAgo: String
    let windows: [QuotaWindow]

    var primaryPercent: Int {
        Int(windows.first?.usedPercentage ?? 0)
    }
}

// Matches the exact JSON dictionary from `hearth usage --json`
struct HearthRow: Decodable {
    let provider: String
    let plan: String
    let fiveHour: Double?
    let week: Double?
    let weekResetsAt: Double?
    let remainingPerDay: Double?
}
