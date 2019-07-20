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
    @IBOutlet var wordCountText : UILabel!
    
    let metrics = [Metric.headLevel, Metric.speakingRate]
    var vc: ViewController?
    
    var duration: TimeInterval?
    
    var totalWords: Int?
    
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
        durationText.text = "\(round(duration ?? 0))s"
        
        for key in metrics {
            print(key)
            let metricValue = sessionStats?[key]?.overallScore()
            
            switch key {
            case Metric.speakingRate:
                let val = Double(totalWords!) / duration!
                overallScore += Double(pow(((val) - 150), 2) / 5)
                speakingRateScoreText.text = "\(floor(600 * val) / 10)"
            case Metric.headLevel:
                overallScore += Double((metricValue ?? 0))
                headLevelScoreText.text = "\(metricValue ?? -1)"
            case Metric.blacklistRate:
                break
            default: break
            }
        }
        
        let blacklistRate = sessionStats![Metric.blacklistRate]!.allSamples.count / totalWords!
        overallScore += Double((blacklistRate) * 10)
        blacklistScoreText.text = "\(blacklistRate)"
        
        wordCountText.text = "\(totalWords ?? 0)"
        
        overallScore = Double(round(overallScore)/100)
        overallScoreText.text = "\(overallScore)"
        
    }
    
}
