//
//  StatisticsViewController.swift
//  whitespace
//
//  Created by Corey Hu on 7/20/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet var speakingRateScoreText : UILabel!
    @IBOutlet var headLevelScoreText : UILabel!
    @IBOutlet var blacklistScoreText : UILabel!
    
    @IBOutlet var overallScoreText : UILabel!
    
    @IBOutlet var durationText : UITextField!
    
    let metrics = [Metric.headLevel, Metric.speakingRate]
    var vc: ViewController?
    
    var duration: TimeInterval?
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
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
