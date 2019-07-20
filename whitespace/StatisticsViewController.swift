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
    
    let metrics = [Metric.headLevel, Metric.speakingRate]
    var vc: ViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadStatistics()
    }
    
    func loadStatistics() {
        let sessionStats = vc?.manager.statistics
        
        for key in metrics {
            print(key)
            let metric = sessionStats?[key]?.score()
            
            switch key {
            case Metric.speakingRate:
                speakingRateScoreText.text = "\(metric ?? -1)"
            case Metric.headLevel:
                headLevelScoreText.text = "\(metric ?? -1)"
            case Metric.blacklistRate:
                blacklistScoreText.text = "\(metric ?? -1)"
            default: break
            }
        }
    }
    
    
}
