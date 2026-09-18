// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import SwiftUI

struct HourlyBeepSettingsSection: View {
    @ObservedObject private var l10n = L10n.shared
    @AppStorage(DefaultsKey.hourlyBeepEnabled) private var hourlyBeepEnabled = false
    @AppStorage(DefaultsKey.hourlyBeepVolumeCap) private var hourlyBeepVolumeCap = Double(HourlyBeepSupport.defaultVolumeCap)
    @AppStorage(DefaultsKey.hourlyBeepSound) private var hourlyBeepSound = HourlyBeepSupport.defaultSoundName

    private let availableSounds = HourlyBeepSupport.availableSystemSounds()

    var body: some View {
        let strings = FeatureStrings.hourlyBeep(l10n.language)
        Section(strings.pageTitle) {
            Toggle(strings.enabled, isOn: $hourlyBeepEnabled)
                .onChange(of: hourlyBeepEnabled) { _, _ in
                    HourlyBeepService.shared.syncWithPreferences()
                }

            if hourlyBeepEnabled {
                Picker(strings.sound, selection: $hourlyBeepSound) {
                    ForEach(availableSounds, id: \.self) { soundName in
                        if soundName == HourlyBeepSupport.defaultSoundName {
                            Text("\(soundName) (\(strings.defaultSound))")
                                .tag(soundName)
                        } else {
                            Text(soundName)
                                .tag(soundName)
                        }
                    }
                }
                .onChange(of: hourlyBeepSound) { _, newSound in
                    HourlyBeepService.shared.playPreview(soundName: newSound, volumeCap: Float(hourlyBeepVolumeCap))
                }
                .onAppear {
                    if !availableSounds.contains(hourlyBeepSound) {
                        hourlyBeepSound = HourlyBeepSupport.defaultSoundName
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(strings.volumeCap)
                        Spacer()
                        Text("\(Int((hourlyBeepVolumeCap * 100).rounded()))%")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Slider(value: $hourlyBeepVolumeCap, in: 0.05...0.50, step: 0.01)
                }
                .padding(.vertical, 2)

                HStack {
                    Spacer()
                    Button {
                        HourlyBeepService.shared.playPreview(soundName: hourlyBeepSound, volumeCap: Float(hourlyBeepVolumeCap))
                    } label: {
                        Label(strings.testSound, systemImage: "speaker.wave.2")
                    }
                }

                Text(strings.volumeCapCaption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
