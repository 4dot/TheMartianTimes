//
//  Sequence+Group.swift
//  TheMartianTimes
//
//  Created by chanick park on 6/11/21.
//  Copyright © 2021 Chanick Park. All rights reserved.
//

import Foundation


extension Sequence {
    /**
     * @desc Group by sequences's member variable
     * @return (key, value) tuple array
     */
    func group<T:Comparable>(by:KeyPath<Element,T>) -> [(key:T, values:[Element])]{
        
        return self.reduce([]){ (accumulator, element) in
            
            var accumulator = accumulator
            var result :(key:T,values:[Element]) = accumulator.first(where:{ $0.key == element[keyPath:by]}) ?? (key: element[keyPath:by], values:[])
            result.values.append(element)
            if let index = accumulator.firstIndex(where: { $0.key == element[keyPath: by]}){
                accumulator.remove(at: index)
            }
            accumulator.append(result)
            
            return accumulator
        }
    }
}
