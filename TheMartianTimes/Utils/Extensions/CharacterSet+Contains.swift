//
//  CharacterSet.swift
//  TheMartianTimes
//
//  Created by Chanick on 7/16/21.
//

import Foundation

extension CharacterSet {
    func containsUnicodeScalars(of character: Character) -> Bool {
        return character.unicodeScalars.allSatisfy(contains(_:))
    }
}
