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
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        if isRightAnswer {
            resultLabel.text = "Well done!"
        } else {
            resultLabel.text = "Sorry! It was actually:"
        }
    }
}
