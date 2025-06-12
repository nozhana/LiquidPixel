//
//  LiquidPixelModifier.swift
//  FilterMixer
//
//  Created by Nozhan A. on 6/12/25.
//

import simd
import SwiftUI

struct LiquidPixelModifier: ViewModifier {
    @State private var dragLocation = CGPoint.zero
    @State private var dragVelocity = CGSize.zero
    
    func body(content: Content) -> some View {
        content
            .drawingGroup()
            .layerEffect(LPShaderLibrary.liquidPixel(
                .float2(dragLocation),
                .float2(dragVelocity)
            ), maxSampleOffset: .zero)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.linear(duration: 0.1)) {
                            dragLocation = value.location
                            dragVelocity = value.velocity.applying(.init(scaleX: 0.3, y: 0.3))
                        }
                    }
                    .onEnded { value in
                        withAnimation(.easeOut(duration: 0.4)) {
                            dragVelocity = .zero
                        }
                    }
            )
            .sensoryFeedback(trigger: dragVelocity) { _, newValue in
                let distance = sqrt(newValue.width * newValue.width + newValue.height * newValue.height)
                guard distance > .zero else { return nil }
                let intensity = simd_smoothstep(0, 400, distance)
                return .impact(weight: .medium, intensity: intensity)
            }
    }
}

public extension View {
    func liquidPixel() -> some View {
        modifier(LiquidPixelModifier())
    }
}

#Preview {
    Text(Array(repeating: "Hello world! ", count: 100).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines))
        .font(.system(size: 42, weight: .heavy))
        .foregroundStyle(.primary)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background.secondary)
        .liquidPixel()
}
