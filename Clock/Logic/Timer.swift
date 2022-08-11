//
//  Timer.swift
//  Clock
//
//  Created by Andrii Halushka on 11.08.2022.
//

import Foundation
import Combine

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
     
    private let step: Double
    
    init(timerStepInFractionOfSecond: Double = 1) {
        self.step = timerStepInFractionOfSecond
    }
    
    @Published var state = TimerState.idle
    @Published var currentTime = TimerTime()
    
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

extension TimerObservedObject {
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
}
