//
//  Comparable+.swift
//  LiquidPixel
//
//  Created by Nozhan A. on 6/12/25.
//

import Foundation

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
