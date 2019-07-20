//
//  CaptureManager.swift
//  whitespace
//
//  Created by Corey Hu on 7/20/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

enum Metric {
    case speakingRate
    case headLevel
    case none
    
    func toString() -> String {
        switch self {
        case .speakingRate:
            return "Speaking Rate"
        case .headLevel:
            return "Head Level"
        default:
            return "Unknown"
        }
    }
    
    func statistic() -> Statistic {
        switch self {
        case .speakingRate:
            return MeanFloatStatistic(len: 100, th: 150)
        case .headLevel:
            return MeanFloatStatistic(len: 100, th: 0.4)
        default:
            return MeanFloatStatistic(len: 0, th: 1)
        }
    }
    
    var target: Any {
        switch self {
        case .speakingRate:
            return 0
        case .headLevel:
            return 0
        default:
            return 0
        }
    }
}

class CaptureManager: NSObject {
    
    static var timeout = TimeInterval(10)
    
    var lastAlert: Date
    
    var statistics: [Metric: Statistic]
    
    var vc: ViewController?
    
    init(metrics: [Metric]) {
        statistics = [:]
        for metric in metrics {
            statistics[metric] = metric.statistic()
        }
        
        lastAlert = Date()
    }
    
    func clearAll() {
        for (_, statistic) in statistics {
            statistic.clearSamples()
        }
        
        lastAlert = Date()
    }
    
    func addSample(_ sample: Any, To metric: Metric) {
        let statistic = statistics[metric]
        statistic?.addSample(sample: sample)
        if statistic?.shouldAlert() ?? false {
            alert(metric, statistic: statistic!)
        }
    }
    
    func beep() {
        print("Beep")
        vc?.playAudio(filename: "ooga_booga")
    }
    
    func alert(_ metric: Metric, statistic: Statistic) {
        // TODO
        if Date().timeIntervalSince(lastAlert) >= CaptureManager.timeout {
            print("Alert")
            statistic.clear()
            vc?.alert(text: metric.toString())
            lastAlert = Date()
        }
    }
    
}
