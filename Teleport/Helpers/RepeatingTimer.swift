//
//  RepeatingTimer.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/8/20.
//

import Foundation

class RepeatingTimer {

    var timeInterval: TimeInterval {
        didSet {
            resetTimer(with: timeInterval)
        }
    }
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        resetTimer(with: timeInterval)
    }
    
    private lazy var timer: DispatchSourceTimer? = makeTimer(interval: timeInterval)

    var eventHandler: (() -> Void)?

    private enum State {
        case suspended
        case resumed
    }

    private var state: State = .suspended

    deinit {
        timer?.setEventHandler {}
        timer?.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }

    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer?.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer?.suspend()
    }
}

extension RepeatingTimer {
    private func resetTimer(with interval: TimeInterval) {
        let shouldResume = state == .resumed
        if timer != nil {
            timer?.setEventHandler {}
            timer?.cancel()
            if state == .suspended {
                timer?.resume()
            }
            state = .suspended
        }
        timer = makeTimer(interval: timeInterval)
        if shouldResume {
            timer?.resume()
            state = .resumed
        }
    }
    
    private func makeTimer(interval: TimeInterval) -> DispatchSourceTimer {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }
}

