//
//  SettingsViewController.swift
//  whitespace
//
//  Created by Kevin Hu on 7/19/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var vc: ViewController!
    
    var metrics: [Metric] = [.speakingRate, .headLevel]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MetricCell")
        let metric = metrics[indexPath.row]
        
        let label = cell?.viewWithTag(1) as? UILabel
        label?.text = metric.toString()
        
        cell?.accessoryType = vc.enabledMetrics.contains(metric) ? .checkmark : .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metric = metrics[indexPath.row]
        
        if vc.enabledMetrics.contains(metric) {
            vc.enabledMetrics.removeAll { item -> Bool in
                item == metric
            }
        } else {
            vc.enabledMetrics.append(metric)
        }
        
        tableView.reloadData()
    }
}
