//
//  Matrix+Normalization.swift
//  
//
//  Created by Hongyu Shi on 2021/5/11.
//

import Foundation
import LANumerics

extension Vector where Element: BinaryFloatingPoint {
    public mutating func l1Normalize() {
        var sum = Element.zero
        for element in self { sum += element }
        for i in 0 ..< count { self[i] /= sum }
    }
}

extension Matrix where Element: BinaryFloatingPoint {
    public mutating func columnWiseNormalize() {
        for i in 0 ..< rows {
            var sum = Element.zero
            for j in 0 ..< columns { sum += self[i, j] }
            for j in 0 ..< columns { self[i, j] /= sum }
        }
    }
}
