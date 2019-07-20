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
    
    let metrics = [Metric.headLevel, Metric.speakingRate]
    var vc: ViewController?
    
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
