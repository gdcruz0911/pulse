import Foundation

enum HearthReader {
    static let hearthBinary =
        "/Users/gdcruz/Library/Application Support/Hearth/runtime/current/bin/hearth"

    static func fetchProviders() -> [ProviderUsage] {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: hearthBinary)
        process.arguments = ["usage", "--json"]

        let outPipe = Pipe()
        process.standardOutput = outPipe
        process.standardError = Pipe()

        do {
            try process.run()
            process.waitUntilExit()

            let data = outPipe.fileHandleForReading.readDataToEndOfFile()

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let rows = try decoder.decode([HearthRow].self, from: data)

            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let nowStamp = "updated \(formatter.string(from: Date()))"

            return rows.map { mapRowToProvider($0, updatedStamp: nowStamp) }
        } catch {
            print("Failed to run hearth usage --json: \(error)")
            return []
        }
    }

    private static func mapRowToProvider(_ row: HearthRow, updatedStamp: String) -> ProviderUsage {
        let weekResetString: String
        if let ts = row.weekResetsAt {
            let date = Date(timeIntervalSince1970: ts)
            let formatter = DateFormatter()
            formatter.dateFormat = "E HH:mm"
            weekResetString = "resets \(formatter.string(from: date))"
        } else {
            weekResetString = "awaiting sample"
        }

        let fiveHourNote: String
        if let leftPerDay = row.remainingPerDay {
            fiveHourNote = "\(leftPerDay)% / day left"
        } else {
            fiveHourNote = row.fiveHour == nil ? "no active window" : "active"
        }

        let icon: String
        switch row.provider {
        case "claude": icon = "sparkles"
        case "codex": icon = "terminal"
        default: icon = "bolt.horizontal.circle"
        }

        return ProviderUsage(
            id: row.provider,
            name: row.provider.capitalized,
            planTier: row.plan.uppercased(),
            iconName: icon,
            updatedAgo: updatedStamp,
            windows: [
                QuotaWindow(
                    label: "5-hour",
                    usedPercentage: row.fiveHour ?? 0,
                    resetText: fiveHourNote
                ),
                QuotaWindow(
                    label: "Weekly",
                    usedPercentage: row.week ?? 0,
                    resetText: weekResetString
                ),
            ]
        )
    }
}
