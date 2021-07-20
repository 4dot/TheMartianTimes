//
//  LocalSettings.swift
//  TheMartianTimes
//
//  Created by Chanick on 7/6/21.
//

import Foundation



enum LanguageType : Int {
    case english = 0
    case martian
}

protocol Settings {
    func saveActiveLanguage(language: Int)
    func retrieveActiveLanguage() -> Int
}

class LocalSettings: Settings {
    // Singleton Class
    static var shared : LocalSettings {
        struct Singleton {
            static let instance = LocalSettings()
        }
        return Singleton.instance
    }
    
    private let languageKey = "currentLanguage"

    func saveActiveLanguage(language: Int) {
        UserDefaults.standard.set(language, forKey: languageKey)
    }

    func retrieveActiveLanguage() -> Int {
        return  UserDefaults.standard.integer(forKey: languageKey)
    }
}
