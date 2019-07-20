//
//  ViewController+Debug.swift
//  whitespace
//
//  Created by Kevin Hu on 7/20/19.
//  Copyright © 2019 Corey Hu. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebugCell")
        
        let metricLabel = cell?.viewWithTag(1) as? UILabel
        let valueLabel = cell?.viewWithTag(2) as? UILabel
        
        metricLabel?.text = "Secs Elapsed"
        valueLabel?.text = "\(floor(Date().timeIntervalSince(startTime ?? Date()) * 10) / 10)"
        
        return cell!
    }
    
}
