//
//  LearnTableViewController.swift
//  OtoscopeSimulator
//
//  Created by John Holcroft on 07/09/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import UIKit

class LearnTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Conditions.TestSet.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let condition = Conditions.TestSet[(indexPath as NSIndexPath).row]
        
        let isLocked = Conditions.IsLocked(condition)
        
        let reuseId = isLocked ?  "LockedCondition" : "Condition"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = condition.name
        cell.imageView?.image = UIImage(named:condition.thumbnailName)

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsViewController = segue.destination as? LearnDetailViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let selectedCondition = Conditions.TestSet[(indexPath as NSIndexPath).row]
        detailsViewController.condition = selectedCondition
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
