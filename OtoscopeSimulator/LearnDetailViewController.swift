//
//  LearnDetailViewController.swift
//  OtoscopeSimulator
//
//  Created by John Holcroft on 07/09/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import UIKit

class LearnDetailViewController: UIViewController {
    
    var condition: Condition = Conditions.Normal
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionDescription: UILabel!
    
    override func viewDidLoad() {
        conditionDescription.text = condition.informationText
        conditionImageView.image = UIImage(named: condition.thumbnailName)
        navigationItem.title = condition.name
    }
}
