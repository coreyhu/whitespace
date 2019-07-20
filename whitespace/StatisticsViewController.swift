//
//  StatisticsViewController.swift
//  whitespace
//
//  Created by Corey Hu on 7/20/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet var speakingRateScoreText : UITextField!
    @IBOutlet var headLevelScoreText : UITextField!
    @IBOutlet var blacklistScoreText : UITextField!
    @IBOutlet var overallScoreText : UITextField!
    
    @IBOutlet var durationText : UITextField!
    
    let metrics = [Metric.headLevel, Metric.speakingRate]
    var vc: ViewController?
    
    var duration: TimeInterval?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadStatistics()
    }
    
    func loadStatistics() {
        let sessionStats = vc?.manager.statistics
        
        durationText.text = "\(duration ?? 0)"
        
        for key in metrics {
            print(key)
            let metricValue = sessionStats?[key]?.score()
            
            switch key {
            case Metric.speakingRate:
                speakingRateScoreText.text = "\(metricValue ?? -1)"
            case Metric.headLevel:
                headLevelScoreText.text = "\(metricValue ?? -1)"
            case Metric.blacklistRate:
                blacklistScoreText.text = "\(metricValue ?? -1)"
            default: break
            }
        }
    }
    
    func overallScore() {
        
    }
    
    
}
