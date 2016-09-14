//
//  UnlockScreenViewController.swift
//  OtoscopeSimulator
//
//  Created by John Holcroft on 07/09/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import UIKit

class UnlockScreenViewController: UIViewController {
    
    @IBAction func unlockButtonPressed() {
        Conditions.IsExtraContentUnlocked = true
        self.navigationController?.popViewController(animated: true)
    }
}
