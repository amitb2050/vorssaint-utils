// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import Foundation

enum HourlyBeepSupport {
    static let defaultVolumeCap: Float = 0.12
    static let defaultSoundName = "Glass"

    /// Calculates the next top-of-the-hour fire date strictly after `now`.
    static func nextFireDate(after now: Date = Date(), calendar: Calendar = .autoupdatingCurrent) -> Date {
        if let next = calendar.nextDate(after: now,
                                       matching: DateComponents(minute: 0, second: 0),
                                       matchingPolicy: .nextTime),
           next > now {
            return next
        }
        let current = now.timeIntervalSinceReferenceDate
        let nextHour = (floor(current / 3600.0) + 1.0) * 3600.0
        return Date(timeIntervalSinceReferenceDate: nextHour)
    }

    /// Calculates relative volume capped against current system volume.
    ///
    /// Following Itsycal's logic:
    /// - If system volume is 1.0 and cap is 0.12, relative volume is 0.12 (effective output = 0.12).
    /// - If system volume is 0.5 and cap is 0.12, relative volume is 0.24 (effective output = 0.12).
    /// - If system volume is below cap (e.g. 0.08), relative volume is 1.0 (plays at current system volume without amplification).
    /// - If system volume is 0 or muted, returns 0.
    static func relativeVolume(systemVolume: Float, cap: Float) -> Float {
        guard systemVolume.isFinite && systemVolume > 0.001 else { return 0 }
        let safeCap = max(0.01, min(1.0, cap.isFinite ? cap : defaultVolumeCap))
        if systemVolume >= safeCap {
            return min(1.0, safeCap / systemVolume)
        }
        return 1.0
    }

    /// Returns standard macOS alert sounds available in /System/Library/Sounds.
    static func availableSystemSounds() -> [String] {
        let systemSoundsDir = "/System/Library/Sounds"
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: systemSoundsDir) else {
            return [defaultSoundName]
        }
        var names = [String]()
        for file in files where !file.hasPrefix(".") {
            let url = URL(fileURLWithPath: file)
            let name = url.deletingPathExtension().lastPathComponent
            if NSSound(named: name) != nil {
                names.append(name)
            }
        }
        return names.sorted()
    }

    /// Loads the chime sound:
    /// - Resolves requested sound name via NSSound.
    /// - Falls back to default system sound ("Tink") if unavailable.
    static func sound(named soundName: String? = nil) -> NSSound? {
        let selected = (soundName ?? UserDefaults.standard.string(forKey: DefaultsKey.hourlyBeepSound)) ?? defaultSoundName
        let trimmed = selected.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmed.isEmpty, let sound = NSSound(named: trimmed) {
            return sound
        }

        if let fallback = NSSound(named: defaultSoundName) {
            return fallback
        }

        return nil
    }
}
