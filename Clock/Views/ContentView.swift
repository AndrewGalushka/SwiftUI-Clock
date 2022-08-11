//
//  ContentView.swift
//  Clock
//
//  Created by Andrii Halushka on 05.08.2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var timer = TimerObservedObject(timerStepInFractionOfSecond: 0.08)
    @State private var circularProgressValue: CGFloat = 0
    
    var body: some View {
        VStack {
            CircularProgressView(progress: .constant(circularProgressValue), lineWidth: 32)
                .padding(.horizontal, 64)
                .overlay {
                    HStack(spacing: 0) {
                        Text(timer.formattedTime.hours)
                        Text(":")
                        Text(timer.formattedTime.minutes)
                        Text(":")
                        Text(timer.formattedTime.seconds)
                        Text(":")
                        Text(timer.formattedTime.miliseconds)
                    }
                    .font(.system(size: 32, weight: .semibold).monospacedDigit())
                }
                .onChange(of: timer.currentTime) { newValue in
                    withAnimation {
                        circularProgressValue = (CGFloat(timer.currentTime.seconds) / 60) + (CGFloat(timer.currentTime.miliseconds) / 1000 / 60)
                    }
                }
            
            HStack(spacing: 30) {
                startPauseButton()
                
                CircularControlButton(
                    title: "Reset",
                    fill: LinearGradient(colors: [Color.red.opacity(0.2), .winterWhite], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .onTapGesture {
                    timer.reset()
                }
            }
            .padding(.horizontal, 64)
            .padding(.top, 32)
        }
    }
    
    func startPauseButton() -> some View {
        let title = {
            switch timer.state {
            case .idle:
                return "Start"
            case .paused:
                return "Resume"
            case .active:
                return "Pause"
            }
        }()
        
        let action = {
            switch timer.state {
            case .idle:
                timer.start()
            case .paused:
                timer.resume()
            case .active:
                timer.pause()
            }
        }
        
        return CircularControlButton(
            title: title,
            fill: LinearGradient(colors: [Color.black.opacity(0.1), .winterWhite], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .onTapGesture {
            action()
        }
    }
}

extension ContentView {
    struct CircularControlButton<Background: View>: View {
        let title: String
        let fill: Background
        var body: some View {
            ZStack {
                Circle()
                    .stroke(style: SwiftUI.StrokeStyle(
                        lineWidth: 1)
                    )
                    .foregroundColor(Color.winterWhite.opacity(0.2))
                    .background(fill)
                    .overlay {
                        Text(title).font(.system(size: 24, weight: .medium))
                    }
                    .clipShape(Circle())
                    .shadow(color: Color.winterWhite, radius: 6)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
