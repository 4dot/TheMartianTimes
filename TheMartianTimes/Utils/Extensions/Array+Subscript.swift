//
//  Array+Subscript.swift
//  TheMartianTimes
//
//  Created by Park, Chanick on 6/11/21.
//  Copyright © 2021 Chanick Park. All rights reserved.
//

import Foundation


extension Array {
    /**
     * @desc safe accee with index
     * @param index
     * @return Element optional
     */
    subscript (safe index: Index) -> Element? {
        return index < count ? self[index] : nil
    }
}
