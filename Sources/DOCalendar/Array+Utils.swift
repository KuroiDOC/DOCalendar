//
//  Array+Utils.swift
//  
//
//  Created by Daniel Otero on 1/6/23.
//

import Foundation

extension Array {
    func shiftLeft(positions: Int) -> Self {
        let n = self.count
        var shiftedArray = self

        for i in 0..<n {
            let newIndex = (i + positions) % n
            shiftedArray[i] = self[newIndex]
        }

        return shiftedArray
    }
}
