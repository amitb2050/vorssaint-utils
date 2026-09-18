// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import Combine
import Foundation

/// Core background service that schedules and plays the hourly chime.
/// Strictly decoupled from UI and views.
final class HourlyBeepService: ObservableObject {
    static let shared = HourlyBeepService()

    @Published private(set) var isRunning: Bool = false

    private var timer: Timer?
    private var sleepObserver: Any?
    private var clockObserver: Any?

    private init() {}

    func syncWithPreferences() {
        let defaults = UserDefaults.standard
        guard AppFeature.hourlyBeep.isAvailable(in: defaults),
              defaults.bool(forKey: DefaultsKey.hourlyBeepEnabled) else {
            stop()
            return
        }
        start()
    }

    func start() {
        timer?.invalidate()
        timer = nil

        attachObserversIfNeeded()
        scheduleNextChime()
        isRunning = true
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        detachObservers()
        isRunning = false
    }

    private func attachObserversIfNeeded() {
        guard sleepObserver == nil else { return }
        sleepObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleNextChime()
        }

        clockObserver = NotificationCenter.default.addObserver(
            forName: .NSSystemClockDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.scheduleNextChime()
        }
    }

    private func detachObservers() {
        if let obs = sleepObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(obs)
            sleepObserver = nil
        }
        if let obs = clockObserver {
            NotificationCenter.default.removeObserver(obs)
            clockObserver = nil
        }
    }

    private func scheduleNextChime() {
        timer?.invalidate()
        timer = nil

        let defaults = UserDefaults.standard
        guard AppFeature.hourlyBeep.isAvailable(in: defaults),
              defaults.bool(forKey: DefaultsKey.hourlyBeepEnabled) else {
            stop()
            return
        }

        let fireDate = HourlyBeepSupport.nextFireDate(after: Date())
        let newTimer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
    }

    @objc private func timerFired() {
        let defaults = UserDefaults.standard
        guard AppFeature.hourlyBeep.isAvailable(in: defaults),
              defaults.bool(forKey: DefaultsKey.hourlyBeepEnabled) else {
            stop()
            return
        }

        // Reschedule for next hour before playing chime
        scheduleNextChime()

        playChime()
    }

    func playChime(soundName: String? = nil, volumeCap: Float? = nil) {
        // Respect system mute
        if AppVolumeMixer.systemOutputIsMuted() == true {
            return
        }

        let defaults = UserDefaults.standard
        let cap = volumeCap ?? Float(defaults.double(forKey: DefaultsKey.hourlyBeepVolumeCap))
        let name = soundName ?? defaults.string(forKey: DefaultsKey.hourlyBeepSound)

        guard let chime = HourlyBeepSupport.sound(named: name) else {
            NSSound.beep()
            return
        }

        let systemVol = AppVolumeMixer.currentSystemOutputVolume() ?? 1.0
        let effectiveCap = cap > 0 ? cap : HourlyBeepSupport.defaultVolumeCap
        let relative = HourlyBeepSupport.relativeVolume(systemVolume: systemVol, cap: effectiveCap)

        chime.volume = relative
        chime.stop()
        chime.play()
    }

    func playPreview(soundName: String? = nil, volumeCap: Float? = nil) {
        playChime(soundName: soundName, volumeCap: volumeCap)
    }
}
