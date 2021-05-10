//
//  MultiLanguage.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 5/3/21.
//

import Foundation

enum Languages: String {
    case en = "en"
    case de = "de"
    case es = "es"
    case fr = "fr"
    case it = "it"
    case ja = "ja"
    case ko = "ko"
    case ms = "ms"
    case nl = "nl"
    case ru = "ru"
    case tr = "tr"
    case vi = "vi"
    case zh_Hans_CN = "zh-Hans-CN"
    case zh_Hant_TW = "zh-Hant-TW"
}

public class MultiLanguage {
    private static func getLanguage() -> Languages{
        Languages.init(rawValue: Locale.current.languageCode ?? "") ?? Languages.en
    }
    public static func getPercentOff() -> String {
        switch (getLanguage()) {
        case .en: return "%@%% Off"
        case .de: return "%@%% Aus"
        case .es: return "%@%% Apagada"
        case .fr: return "-%@%%"
        case .it: return "%@%% via"
        case .ja: return "%@%% オフ"
        case .ko: return "%@%% 할인"
        case .ms: return "%@%% Off"
        case .nl: return "%@%% Uit"
        case .ru: return "%@%% выключенный"
        case .tr: return "%@%% kapalı"
        case .vi: return "%@%% tắt"
        case .zh_Hans_CN: return "%@%% 离开"
        case .zh_Hant_TW: return "%@%% 離開"
        }
    }

    public static func getWasOldPrice() -> String {
        switch (getLanguage()) {
        case .en: return "was %@"
        case .de: return "war %@"
        case .es: return "estaba %@"
        case .fr: return "était %@"
        case .it: return "era %@"
        case .ja: return "ました %@"
        case .ko: return ", 기존가: %@"
        case .ms: return "adalah %@"
        case .nl: return "was %@"
        case .ru: return "был %@"
        case .tr: return "oldu %@"
        case .vi: return "là %@"
        case .zh_Hans_CN: return "曾是 %@"
        case .zh_Hant_TW: return "曾是 %@"
        }
    }
}
