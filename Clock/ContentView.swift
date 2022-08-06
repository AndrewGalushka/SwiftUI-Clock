//
//  ContentView.swift
//  Clock
//
//  Created by Andrii Halushka on 05.08.2022.
//

import SwiftUI
import Combine

struct TimerTime: Equatable {
    static var zero: TimerTime {
        TimerTime(hours: 0, minutes: 0, seconds: 0, miliseconds: 0)
    }
    
    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0, miliseconds: Int = 0) {
        self.hours = hours
        
        self.minutes = minutes
        self.seconds = seconds
        self.miliseconds = miliseconds
    }
    
    var hours: Int = 0
    
    private var _minutes = 0
    var minutes: Int {
        set {
            if newValue >= 60 {
                hours = newValue / 60
                _minutes = newValue % 60
            } else {
                _minutes = newValue
            }
        }
        
        get {
            return _minutes
        }
    }
    
    private var _seconds = 0
    var seconds: Int {
        set {
            if newValue >= 60 {
                minutes += newValue / 60
                _seconds = newValue % 60
            } else {
                _seconds = newValue
            }
        }
        
        get {
            return _seconds
        }
    }
    
    private var _miliseconds = 0
    var miliseconds: Int {
        set {
            if newValue >= 1000 {
                seconds += newValue / 1000
                _miliseconds = newValue % 1000
            } else {
                _miliseconds = newValue
            }
        }
        
        get {
            return _miliseconds
        }
    }
}

class TimerObservedObject: ObservableObject {
    private var token: AnyCancellable?
    private lazy var timerPublisher = Timer.publish(
        every: step,
        tolerance: 0,
        on: Foundation.RunLoop.main,
        in: Foundation.RunLoop.Mode.common
    ).autoconnect()
    
    enum TimerState {
        case idle
        case active
        case paused
    }
     
    @Published var state = TimerState.idle
    
    private let step: Double = 0.08
    @Published var currentTime = TimerTime()
    
    struct FormattedTime {
        let hours: String
        let minutes: String
        let seconds: String
        let miliseconds: String
    }
    
    var formattedTime: FormattedTime {
        func hours() -> String {
            if currentTime.hours < 10 {
                return "0" + "\(currentTime.hours)"
            } else {
                return "\(currentTime.hours)"
            }
        }
        func minutes() -> String {
            let m = currentTime.minutes == 0 ? "00" : "\(currentTime.minutes)"
            
            if m.count == 1 {
                return "0" + m
            } else {
                return m
            }
        }
        
        func seconds() -> String {
            let s = currentTime.seconds == 0 ? "00" : "\(currentTime.seconds)"
            
            if s.count == 1 {
                return "0" + s
            } else {
                return s
            }
        }
        
        func miliseconds() -> String {
            let m = currentTime.miliseconds == 0 ? "00" : "\(currentTime.miliseconds)"
            
            return String(m.prefix(2))
        }
        
        return FormattedTime(
            hours: hours(),
            minutes: minutes(),
            seconds: seconds(),
            miliseconds: miliseconds()
        )
    }
    
    func start() {
        state = .active
        token = timerPublisher
            .sink { _ in
                self.currentTime.miliseconds += Int(1000 * self.step)
            }
    }
    
    func pause() {
        state = .paused
        token?.cancel()
    }
    
    func resume() {
        start()
    }
    
    func reset() {
        currentTime = .zero
    }
}

struct ContentView: View {
    @EnvironmentObject var timer: TimerObservedObject
    @State private var circularProgressValue: CGFloat = 0
    
    var body: some View {
        VStack {
            CircularProgressView(progress: .constant(circularProgressValue), lineWidth: 32)
                .padding(.horizontal, 64)
                .overlay {
                    HStack(spacing: 0) {
                        Text(timer.formattedTime.hours)
                            .frame(minWidth: 45, alignment: .trailing)
                        Text(":")
                        Text(timer.formattedTime.minutes)
                            .frame(width: 45)
                        Text(":")
                        Text(timer.formattedTime.seconds)
                            .frame(width: 45)
                        Text(":")
                        Text(timer.formattedTime.miliseconds)
                            .frame(width: 45)
                    }
                    .font(.system(size: 32, weight: .semibold))
                }
                .onChange(of: timer.currentTime) { newValue in
                    withAnimation {
                        circularProgressValue = (CGFloat(timer.currentTime.seconds) / 60) + (CGFloat(timer.currentTime.miliseconds) / 1000 / 60)
                    }
                }
            
            HStack(spacing: 30) {
                startPauseButton()
                
                CircularControlButton(
                    title: Text("Reset").font(.title2),
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
            title: Text(title).font(.title2),
            fill: LinearGradient(colors: [Color.black.opacity(0.1), .winterWhite], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .onTapGesture {
            action()
        }
    }
}

extension ContentView {
    struct CircularControlButton<Background: View>: View {
        let title: Text
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
                        title
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
            .environmentObject(TimerObservedObject())
    }
}
