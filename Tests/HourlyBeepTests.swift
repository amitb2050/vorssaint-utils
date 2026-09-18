// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

enum HourlyBeepTests {
    static func run(_ suite: TestSuite) {
        suite.run("hourlyBeep/volumeCapping") {
            // Full system volume: relative volume equals cap (0.12 * 1.0 = 0.12 effective output)
            let volAtFull = HourlyBeepSupport.relativeVolume(systemVolume: 1.0, cap: 0.12)
            suite.expectClose(Double(volAtFull), 0.12, "relative volume at 100% system volume")

            // Half system volume: relative volume scales up (0.24 * 0.50 = 0.12 effective output)
            let volAtHalf = HourlyBeepSupport.relativeVolume(systemVolume: 0.5, cap: 0.12)
            suite.expectClose(Double(volAtHalf), 0.24, "relative volume at 50% system volume")

            // System volume below cap: relative volume is 1.0 (plays at current system volume without amplification)
            let volAtLow = HourlyBeepSupport.relativeVolume(systemVolume: 0.08, cap: 0.12)
            suite.expectClose(Double(volAtLow), 1.0, "relative volume below cap is 1.0")

            // System volume zero / muted: relative volume is 0
            let volAtZero = HourlyBeepSupport.relativeVolume(systemVolume: 0.0, cap: 0.12)
            suite.expectClose(Double(volAtZero), 0.0, "relative volume at zero system volume")

            // Negative or invalid volumes safely handled
            let volNegative = HourlyBeepSupport.relativeVolume(systemVolume: -0.5, cap: 0.12)
            suite.expectClose(Double(volNegative), 0.0, "negative system volume returns 0")
        }

        suite.run("hourlyBeep/timing") {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!

            // Given 14:25:30, next fire date should be 15:00:00
            var comps = DateComponents(year: 2026, month: 9, day: 17, hour: 14, minute: 25, second: 30)
            let testDate = calendar.date(from: comps)!
            let nextDate = HourlyBeepSupport.nextFireDate(after: testDate, calendar: calendar)

            let nextComps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextDate)
            suite.expect(nextComps.hour == 15 && nextComps.minute == 0 && nextComps.second == 0,
                         "next fire date from 14:25:30 lands on 15:00:00")
            suite.expect(nextDate > testDate, "next fire date is strictly after current date")

            // Given exactly 14:00:00, next fire date must be 15:00:00 (never same instant)
            comps = DateComponents(year: 2026, month: 9, day: 17, hour: 14, minute: 0, second: 0)
            let topOfHour = calendar.date(from: comps)!
            let nextAfterTop = HourlyBeepSupport.nextFireDate(after: topOfHour, calendar: calendar)
            let nextAfterTopComps = calendar.dateComponents([.hour, .minute, .second], from: nextAfterTop)
            suite.expect(nextAfterTopComps.hour == 15 && nextAfterTopComps.minute == 0,
                         "next fire date from exactly 14:00:00 advances to 15:00:00")

            // Day boundary: 23:59:59 -> 00:00:00 next day
            comps = DateComponents(year: 2026, month: 9, day: 17, hour: 23, minute: 59, second: 59)
            let midnightEve = calendar.date(from: comps)!
            let midnight = HourlyBeepSupport.nextFireDate(after: midnightEve, calendar: calendar)
            let midnightComps = calendar.dateComponents([.day, .hour, .minute], from: midnight)
            suite.expect(midnightComps.day == 18 && midnightComps.hour == 0 && midnightComps.minute == 0,
                         "day boundary advances hour to midnight next day")
        }

        suite.run("hourlyBeep/catalog") {
            suite.expect(AppFeature.hourlyBeep.group == .sound, "hourlyBeep is in .sound group")
            suite.expect(AppFeature.hourlyBeep.enabledKeys == [DefaultsKey.hourlyBeepEnabled, DefaultsKey.hourlyBeepSound],
                         "hourlyBeep enabled keys contains hourlyBeepEnabled and hourlyBeepSound")
            suite.expect(AppFeature.hourlyBeep.permissions.isEmpty, "hourlyBeep requires no special permissions")
            suite.expect(AppFeature.hourlyBeep.energyProfile == .idle, "hourlyBeep energy profile is idle")

            let availableDefault = AppFeature.availabilityDefaults[AppFeature.hourlyBeep.availabilityKey] as? Bool
            suite.expect(availableDefault == false, "hourlyBeep starts uninstalled by default")

            // Dynamic sounds
            let systemSounds = HourlyBeepSupport.availableSystemSounds()
            suite.expect(!systemSounds.isEmpty, "dynamic sound discovery finds macOS system sounds")
            suite.expect(systemSounds.contains("Glass"), "system sounds list includes Glass")
            suite.expect(systemSounds.contains("Tink"), "system sounds list includes Tink")
            suite.expect(systemSounds == systemSounds.sorted(), "dynamically discovered sounds are sorted alphabetically")

            // Default sound
            let chime = HourlyBeepSupport.sound()
            suite.expect(chime != nil, "HourlyBeepSupport.sound() loads default Glass sound")

            let glassExplicit = HourlyBeepSupport.sound(named: "Glass")
            suite.expect(glassExplicit != nil, "HourlyBeepSupport.sound(named: 'Glass') loads Glass")

            // Unknown / missing sound falls back to default Glass sound
            let fallback = HourlyBeepSupport.sound(named: "NonExistentSoundThatDoesNotExist12345")
            suite.expect(fallback != nil, "missing sound falls back to default Glass sound")

            // System sound resolution if available
            if let firstSound = systemSounds.first {
                let resolved = HourlyBeepSupport.sound(named: firstSound)
                suite.expect(resolved != nil, "HourlyBeepSupport.sound(named: '\(firstSound)') resolves correctly")
            }
        }
    }
}
