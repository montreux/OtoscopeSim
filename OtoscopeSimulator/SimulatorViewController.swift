//
//  ViewController.swift
//  OttoscopeSimulator
//
//  Created by John Holcroft on 30/01/2016.
//  Copyright © 2016 John Holcroft. All rights reserved.
//

import UIKit
import CoreMotion

class SimulatorViewController: UIViewController {

    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var ottoscopeImageView: UIImageView!
    
    @IBOutlet weak var xCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var yCentreConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rollValueLabel: UILabel!
    @IBOutlet weak var pitchValueLabel: UILabel!
    @IBOutlet weak var yawValueLabel: UILabel!
    
    @IBOutlet weak var earImageView: UIImageView!
    
    let motionManager = CMMotionManager()
    
    var maxConstraintValue:CGFloat {
        return UIScreen.mainScreen().bounds.height - ottoscopeImageView.frame.height
    }

    @IBAction func xSliderValueChanged(sender: UISlider) {
        let proportion = CGFloat(sender.value)
        let newConstraintValue = (0.5 * maxConstraintValue) - proportion * maxConstraintValue
        
        xCentreConstraint.constant = newConstraintValue
    }

    @IBAction func ySliderValueChanged(sender: UISlider) {
        let proportion = CGFloat(sender.value)
        let newConstraintValue = (0.5 * maxConstraintValue) - proportion * maxConstraintValue
        
        yCentreConstraint.constant = newConstraintValue
    }
    
    override func viewDidAppear(animated: Bool) {
        startHandlingAttitudeChanges()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func startHandlingAttitudeChanges() {
        guard self.motionManager.deviceMotionAvailable else { return }
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
            [weak self](deviceMotion:CMDeviceMotion?, error:NSError?) -> Void in
            
            guard let deviceMotion = deviceMotion, let sSelf = self else { return }
            
            sSelf.rollValueLabel.text = String(format:"%.2f", deviceMotion.attitude.roll)
            sSelf.yCentreConstraint.constant = sSelf.rollValueToConstraintValue(deviceMotion.attitude.roll)
            
            sSelf.yawValueLabel.text = String(format:"%.2f", deviceMotion.attitude.yaw)
            
            sSelf.pitchValueLabel.text = String(format:"%.2f", deviceMotion.attitude.pitch)
            sSelf.earImageView.transform = CGAffineTransformMakeRotation(CGFloat(deviceMotion.attitude.pitch))
        }
    }
    
    func rollValueToConstraintValue(rollValue:Double) -> CGFloat {
        let minRollValue = M_PI_2 - 0.2
        let maxRollValue = M_PI_2 + 0.2
        
        guard rollValue > minRollValue else { return proportionToConstraintValue(1) }
        guard rollValue < maxRollValue else { return proportionToConstraintValue(0) }

        let rollProportion = (maxRollValue - rollValue) / (maxRollValue - minRollValue)
        return proportionToConstraintValue(rollProportion)
    }
    
    func proportionToConstraintValue(proportion:Double) -> CGFloat {
        let newConstraintValue = (0.5 * maxConstraintValue) - CGFloat(proportion) * maxConstraintValue

        return newConstraintValue
    }
}

