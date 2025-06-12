//
//  LiquidPixel.metal
//  LiquidPixel
//
//  Created by Nozhan A. on 6/12/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


[[stitchable]] half4 liquidPixel(float2 p, SwiftUI::Layer a, float2 l, float2 v) {
    float2 m = -v * pow(clamp(1-length(l-p)/190,0.,1.),2) * 1.5;
    half3 c=0;
    for(float i=0; i<10; i++) {
        float s = .175+.005*i;
        c += half3(a.sample(p+s*m).r,a.sample(p+(s+.025)*m).g,a.sample(p+(s+.05)*m).b);
    }
    return half4(c/10,1);
}
