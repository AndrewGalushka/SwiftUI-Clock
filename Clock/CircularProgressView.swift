//
//  CircularProgressView.swift
//  Clock
//
//  Created by Andrii Halushka on 05.08.2022.
//

import SwiftUI

struct CircularProgressView: View {
    @Binding var progress: CGFloat
    let lineWidth: CGFloat
    
    @State private var animatableOpacity: CGFloat = 1
    
    var strokeShape: some ShapeStyle {
        AngularGradient(
            gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
            center: .center,
            startAngle: .degrees(360),
            endAngle: .degrees(0)
        )
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.winterWhite.opacity(0.2), style: StrokeStyle(lineWidth: lineWidth,  lineCap: .round, lineJoin: .round))
            Circle()
                .trim(from: 0.00, to: max(0.001, progress))
                .stroke(strokeShape, style: StrokeStyle(lineWidth: lineWidth,  lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270))
                .opacity(animatableOpacity)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: .constant(0.8), lineWidth: 30)
            .frame(width: 300, height: 300)
    }
}
