// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// Strings for the hourly chime feature. Memberwise init in declaration order,
/// one static per language, all in this file.
struct HourlyBeepFeatureStrings {
    let pageTitle: String
    let hubDescription: String
    let enabled: String
    let sound: String
    let defaultSound: String
    let volumeCap: String
    let volumeCapCaption: String
    let testSound: String
}

extension FeatureStrings {
    static func hourlyBeep(_ language: AppLanguage) -> HourlyBeepFeatureStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        }
    }
}

extension HourlyBeepFeatureStrings {
    static let enUS = HourlyBeepFeatureStrings(
        pageTitle: "Hourly Chime",
        hubDescription: "Play a gentle chime at the top of every hour",
        enabled: "Hourly Chime",
        sound: "Chime sound",
        defaultSound: "Default",
        volumeCap: "Volume limit",
        volumeCapCaption: "Caps the chime volume so it never startles you at high system volumes.",
        testSound: "Test Chime"
    )

    static let ptBR = HourlyBeepFeatureStrings(
        pageTitle: "Sinal Horário",
        hubDescription: "Tocar um sinal suave a cada hora",
        enabled: "Sinal horário",
        sound: "Som do sinal",
        defaultSound: "Padrão",
        volumeCap: "Limite de volume",
        volumeCapCaption: "Limita o volume do sinal para evitar sustos em volumes altos do sistema.",
        testSound: "Testar sinal"
    )

    static let es = HourlyBeepFeatureStrings(
        pageTitle: "Campanada Horaria",
        hubDescription: "Reproducir un sonido suave a cada hora en punto",
        enabled: "Campanada horaria",
        sound: "Sonido de la campanada",
        defaultSound: "Predeterminado",
        volumeCap: "Límite de volumen",
        volumeCapCaption: "Limita el volumen para evitar sobresaltos cuando el volumen del sistema es alto.",
        testSound: "Probar sonido"
    )

    static let de = HourlyBeepFeatureStrings(
        pageTitle: "Stündlicher Signalton",
        hubDescription: "Zu jeder vollen Stunde einen sanften Ton abspielen",
        enabled: "Stündlicher Signalton",
        sound: "Signalton",
        defaultSound: "Standard",
        volumeCap: "Lautstärkebegrenzung",
        volumeCapCaption: "Begrenzt die Lautstärke des Signaltons bei hoher Systemlautstärke.",
        testSound: "Ton testen"
    )

    static let fr = HourlyBeepFeatureStrings(
        pageTitle: "Carillon Horaire",
        hubDescription: "Jouer un carillon discret à chaque heure pile",
        enabled: "Carillon horaire",
        sound: "Son du carillon",
        defaultSound: "Par défaut",
        volumeCap: "Limite de volume",
        volumeCapCaption: "Limite le volume du carillon pour éviter les surprises à volume élevé.",
        testSound: "Tester le son"
    )

    static let it = HourlyBeepFeatureStrings(
        pageTitle: "Segnale Orario",
        hubDescription: "Riproduci un segnale sonoro all’inizio di ogni ora",
        enabled: "Segnale orario",
        sound: "Suono del segnale",
        defaultSound: "Predefinito",
        volumeCap: "Limite volume",
        volumeCapCaption: "Limita il volume del segnale per evitare sorprese ad alto volume di sistema.",
        testSound: "Prova suono"
    )

    static let tr = HourlyBeepFeatureStrings(
        pageTitle: "Saat Başı Sesi",
        hubDescription: "Her saat başında hafif bir ses çal",
        enabled: "Saat başı sesi",
        sound: "Saat başı sesi",
        defaultSound: "Varsayılan",
        volumeCap: "Ses sınırı",
        volumeCapCaption: "Yüksek sistem seslerinde ani ses çıkmasını önlemek için ses seviyesini sınırlar.",
        testSound: "Sesi test et"
    )

    static let ru = HourlyBeepFeatureStrings(
        pageTitle: "Почасовой сигнал",
        hubDescription: "Воспроизводить мягкий сигнал в начале каждого часа",
        enabled: "Почасовой сигнал",
        sound: "Звук сигнала",
        defaultSound: "По умолчанию",
        volumeCap: "Предел громкости",
        volumeCapCaption: "Ограничивает громкость сигнала, чтобы избежать резких звуков при высокой громкости системы.",
        testSound: "Проверить звук"
    )

    static let ja = HourlyBeepFeatureStrings(
        pageTitle: "時報",
        hubDescription: "毎正時に優しいチャイムを鳴らす",
        enabled: "時報",
        sound: "チャイムの音",
        defaultSound: "デフォルト",
        volumeCap: "音量制限",
        volumeCapCaption: "システムの音量が大きいときでもチャイムの音量を控えめに制限します。",
        testSound: "音をテスト"
    )

    static let ko = HourlyBeepFeatureStrings(
        pageTitle: "정각 알림음",
        hubDescription: "매시간 정각마다 부드러운 알림음 재생",
        enabled: "정각 알림음",
        sound: "알림음 종류",
        defaultSound: "기본값",
        volumeCap: "음량 제한",
        volumeCapCaption: "시스템 음량이 클 때 알림음이 너무 크게 울리지 않도록 제한합니다.",
        testSound: "소리 테스트"
    )

    static let zhHans = HourlyBeepFeatureStrings(
        pageTitle: "整点报时",
        hubDescription: "每逢整点播放轻柔的提示音",
        enabled: "整点报时",
        sound: "报时声音",
        defaultSound: "默认",
        volumeCap: "音量上限",
        volumeCapCaption: "限制报时音量，避免在系统音量较高时受到惊吓。",
        testSound: "测试声音"
    )

    static let zhTW = HourlyBeepFeatureStrings(
        pageTitle: "整點報時",
        hubDescription: "每逢整點播放輕柔的提示音",
        enabled: "整點報時",
        sound: "報時聲音",
        defaultSound: "預設",
        volumeCap: "音量上限",
        volumeCapCaption: "限制報時音量，避免在系統音量較高時受到驚嚇。",
        testSound: "測試聲音"
    )

    static let zhHK = HourlyBeepFeatureStrings(
        pageTitle: "整點報時",
        hubDescription: "每逢整點播放輕柔的提示音",
        enabled: "整點報時",
        sound: "報時聲音",
        defaultSound: "預設",
        volumeCap: "音量上限",
        volumeCapCaption: "限制報時音量，避免在系統音量較高時受到驚嚇。",
        testSound: "測試聲音"
    )
}
