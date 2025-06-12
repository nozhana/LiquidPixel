//
//  File.swift
//  LiquidPixel
//
//  Created by Nozhan A. on 6/12/25.
//

import SwiftUI

@dynamicMemberLookup
enum LPShaderLibrary {
    static subscript(dynamicMember name: String) -> ShaderFunction {
        ShaderLibrary.bundle(.module)[dynamicMember: name]
    }
}
