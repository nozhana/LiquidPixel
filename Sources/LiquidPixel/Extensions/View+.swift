//
//  View+.swift
//  LiquidPixel
//
//  Created by Nozhan A. on 6/12/25.
//

import SwiftUI

extension View {
    @ViewBuilder func conditional(_ condition: Bool, ifTrue trueBlock: @escaping (_ content: Self) -> some View, ifFalse falseBlock: @escaping (_ content: Self) -> some View) -> some View {
        if condition {
            trueBlock(self)
        } else {
            falseBlock(self)
        }
    }
}
