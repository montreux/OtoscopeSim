//
//  RevealViewController.swift
//  OtoscopeSimulator
//
//  Created by John Holcroft on 31/01/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import UIKit

class RevealViewController : UIViewController {
    var isRightAnswer = true
    var condition:Condition!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var conditionNameLabel: UILabel!
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    override func viewDidLoad() {
        if isRightAnswer {
            resultLabel.text = "Well done!"
        } else {
            resultLabel.text = "Sorry! It was actually:"
        }
        
        conditionNameLabel.text = condition.name
        conditionDescriptionLabel.text = condition.informationText
        conditionImage.image = UIImage(named: condition.thumbnailName)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
