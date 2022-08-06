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
    var fillColors: FillColors = .classic
    
    enum FillColors {
        case classic
        case custom([Color])
        
        var colors: [Color] {
            switch self {
            case .classic:
                return [.blue, .red, .mint, .blue]
            case .custom(let colors):
                return colors
            }
        }
    }
    
    var strokeGradient: some ShapeStyle {
        AngularGradient(
            gradient: Gradient(colors: fillColors.colors),
            center: .center,
            startAngle: .degrees(360),
            endAngle: .degrees(0)
        )
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.red.opacity(0.05), style: StrokeStyle(lineWidth: lineWidth,  lineCap: .round, lineJoin: .round))
            
            Circle()
                .trim(from: 0.00, to: max(0.001, progress))
                .stroke(strokeGradient, style: StrokeStyle(lineWidth: lineWidth,  lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270))
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularProgressView(progress: .constant(1), lineWidth: 32)
                
            CircularProgressView(progress: .constant(0.8), lineWidth: 32)
        }
        .frame(width: 300, height: 300)
        
    }
}
