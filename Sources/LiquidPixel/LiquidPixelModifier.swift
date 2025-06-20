//
//  LiquidPixelModifier.swift
//  FilterMixer
//
//  Created by Nozhan A. on 6/12/25.
//

import simd
import SwiftUI

struct LiquidPixelModifier: ViewModifier {
    var simultaneous: Bool = false
    var viscosity: CGFloat = 0.5
    var initialize: ((Binding<CGPoint>, Binding<CGSize>) -> Void)?
    @State private var dragLocation = CGPoint.zero
    @State private var dragVelocity = CGSize.zero
    
    func body(content: Content) -> some View {
        let gesture = DragGesture()
            .onChanged { value in
                if dragLocation == .zero {
                    dragLocation = value.location
                }
                withAnimation(.easeIn(duration: 0.1.interpolated(towards: 1.1, amount: viscosity.clamped(to: 0...1)))) {
                    dragLocation = value.location
                    dragVelocity = value.velocity.applying(.init(scaleX: 0.7.interpolated(towards: 0.3, amount: viscosity.clamped(to: 0...1)),
                                                                 y: 0.7.interpolated(towards: 0.3, amount: viscosity.clamped(to: 0...1))))
                }
            }
            .onEnded { value in
                withAnimation(.easeOut(duration: 0.1.interpolated(towards: 0.7, amount: viscosity.clamped(to: 0...1)))) {
                    dragVelocity = .zero
                    dragLocation = value.predictedEndLocation
                } completion: {
                    dragLocation = .zero
                }
            }
        
        content
            .drawingGroup()
            .layerEffect(LPShaderLibrary.liquidPixel(
                .float2(dragLocation),
                .float2(dragVelocity)
            ), maxSampleOffset: .zero)
            .conditional(simultaneous) { content in
                content
                    .simultaneousGesture(gesture)
            } ifFalse: { content in
                content
                    .gesture(gesture)
            }
            .sensoryFeedback(trigger: dragVelocity) { _, newValue in
                let distance = sqrt(newValue.width * newValue.width + newValue.height * newValue.height)
                guard distance > .zero else { return nil }
                let intensity = simd_smoothstep(0, 400, distance)
                return .impact(weight: .medium, intensity: intensity)
            }
            .onAppear {
                if let initialize {
                    initialize($dragLocation, $dragVelocity)
                }
            }
    }
}

public extension View {
    func liquidPixel(registerSimultaneouslyWithOtherGestures: Bool = false, viscosity: CGFloat = 0.5, initialize: ((_ location: Binding<CGPoint>, _ velocity: Binding<CGSize>) -> Void)? = nil) -> some View {
        modifier(LiquidPixelModifier(simultaneous: registerSimultaneouslyWithOtherGestures, viscosity: viscosity, initialize: initialize))
    }
}

#Preview {
    Text(Array(repeating: "Hello world! ", count: 100).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines))
        .font(.system(size: 25, weight: .heavy))
        .foregroundStyle(.primary)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background.secondary)
        .liquidPixel()
}
