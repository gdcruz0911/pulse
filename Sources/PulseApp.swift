import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}

@main
struct PulseApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var providers: [ProviderUsage] = HearthReader.fetchProviders()

    var body: some Scene {
        MenuBarExtra {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                HStack {
                    Text("Pulse Limits")
                        .font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Circle().fill(.green).frame(width: 6, height: 6)
                    Text("Live")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // Loop over each provider and render a card
                ForEach(providers) { provider in
                    VStack(alignment: .leading, spacing: 6) {
                        // Card Title Row
                        HStack {
                            Image(systemName: provider.iconName)
                                .foregroundStyle(.orange)
                            Text(provider.name)
                                .font(.system(size: 12, weight: .semibold))
                            Text(provider.planTier)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(provider.updatedAgo)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }

                        // Progress Bar Rows
                        ForEach(provider.windows) { window in
                            HStack(spacing: 8) {
                                Text(window.label)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 45, alignment: .leading)

                                ProgressView(value: window.usedPercentage, total: 100)
                                    .tint(window.usedPercentage > 75 ? .orange : .blue)

                                Text("\(Int(window.usedPercentage))%")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .frame(width: 30, alignment: .trailing)

                                Text(window.resetText)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 85, alignment: .trailing)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Divider()

                // Footer
                HStack {
                    Button("Quit Pulse") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q", modifiers: .command)
                    .buttonStyle(.plain)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Button("Refresh") {
                        providers = HearthReader.fetchProviders()
                    }
                    .keyboardShortcut("r", modifiers: .command)
                    .buttonStyle(.plain)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Spacer()
                }
            }
            .padding(12)
            .frame(width: 300)
        } label: {
            // Compact Top Menu Bar Readout
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                Text("\(providers.first?.primaryPercent ?? 0)%")
            }
        }
        .menuBarExtraStyle(.window)
    }
}
