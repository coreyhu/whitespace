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
    @IBOutlet var durationText : UILabel!
    
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
        var overallScore = 0.0
        durationText.text = "\(duration ?? 0)"
        
        for key in metrics {
            print(key)
            let metricValue = sessionStats?[key]?.score()
            
            switch key {
            case Metric.speakingRate:
                overallScore += Double(pow(((metricValue ?? 0) - 150), 2) / 5)
                speakingRateScoreText.text = "\(metricValue ?? -1)"
            case Metric.headLevel:
                overallScore += Double((metricValue ?? 0))
                headLevelScoreText.text = "\(metricValue ?? -1)"
            case Metric.blacklistRate:
                overallScore += Double((metricValue ?? 0) / 5)
                blacklistScoreText.text = "\(metricValue ?? -1)"
            default: break
            }
        }
        overallScore = Double(round(100*overallScore)/100)
        overallScoreText.text = "\(overallScore)"
        
    }
    
    func overallScore() {
        
    }
    
    
}
