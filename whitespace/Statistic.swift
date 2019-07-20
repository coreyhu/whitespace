//
//  Statistic.swift
//  whitespace
//
//  Created by Corey Hu on 7/20/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit
import AVFoundation

class Statistic: NSObject {
    
    var allSamples: [Any]
    var samples: [Any]
    var captureLength: Int
    var threshold: Float
    
    init(len: Int, th: Float) {
        samples = []
        allSamples = []
        captureLength = len
        threshold = th
    }
    
    func clearSamples() {
        samples = []
        allSamples = []
    }
    
    func addSample(sample: Any) {
        samples.append(sample)
        allSamples.append(sample)
        if samples.count > captureLength {
            samples.removeFirst()
        }
    }
    
    func score() -> Float {
        // Override in subclasses
        return 0
    }
    
    func shouldAlert() -> Bool {
        return score() >= threshold
    }
    
    func clear() {
        samples = []
        allSamples = []
    }
}

class MeanFloatStatistic: Statistic {
    
    override func score() -> Float {
        var total: Float = 0.0
        for sample in samples {
            total += sample as? Float ?? 0
        }
        let mean = total / Float(samples.count)
        print("\(mean)")
        return mean
    }
}

class DeviationFloatStatistic: Statistic {
    
    override func score() -> Float {
        var total: Float = 0.0
        for sample in samples {
            total += sample as? Float ?? 0
        }
        let mean = total / Float(samples.count)
        
        var v: Float = 0.0
        for sample in samples {
            let sampleF = sample as? Float ?? mean
            v += (sampleF-mean)*(sampleF-mean)
        }
        return v / (Float(samples.count) - 1)
    }
    
}
