//
//  TimerTime.swift
//  Clock
//
//  Created by Andrii Halushka on 08.08.2022.
//

import Foundation

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
