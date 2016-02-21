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

    var presentedCondition:Condition = Conditions.Normal
    var shownConditions:[String] = []
    
    @IBOutlet weak var ottoscopeImageView: UIImageView!
    @IBOutlet weak var earImageView: UIImageView!
    @IBOutlet weak var xCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var yCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var holdThumbHereLabel: UILabel!
    @IBOutlet weak var moveOnLabel: UILabel!
    
    let motionManager = CMMotionManager()
    var centreYawValue:Double?
    var startXCentreConstraintConstant:CGFloat = 0
    
    var maxConstraintValue:CGFloat {
        return UIScreen.mainScreen().bounds.height - ottoscopeImageView.frame.height
    }
    
    override func viewDidLoad() {
        self.earImageView.hidden = true
        startXCentreConstraintConstant = self.xCentreConstraint.constant
    }
    
    override func viewDidAppear(animated: Bool) {
        guard (self.shownConditions.count != Conditions.TestSet.count) else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        self.presentedCondition = self.chooseNextRandomCondition(from:Conditions.TestSet)
        self.shownConditions.append(presentedCondition.name)

        self.setConditionImage(presentedCondition.imageName)
        self.holdThumbHereLabel.hidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func chooseNextRandomCondition(from conditionSet:[Condition]) -> Condition {
        
        var chosenCondition:Condition!
        
        let maxRandom = UInt32(conditionSet.count)
        
        repeat {
            let randomIndex = Int(arc4random_uniform(maxRandom))
            chosenCondition = conditionSet[randomIndex]
        } while self.shownConditions.contains(chosenCondition.name)
        
        return chosenCondition
    }
    
    func setConditionImage(imageName:String) {
        self.earImageView.image = UIImage(named: self.presentedCondition.imageName)
    }
    
    func startHandlingAttitudeChanges() {
        guard self.motionManager.deviceMotionAvailable else { return }
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
            [weak self](deviceMotion:CMDeviceMotion?, error:NSError?) -> Void in
            
            guard let deviceMotion = deviceMotion, let sSelf = self else { return }
            
            if sSelf.centreYawValue == nil {
                sSelf.centreYawValue = deviceMotion.attitude.yaw
            }
            
            let isUpsideDown = deviceMotion.attitude.roll < 0
            let rollValue = !isUpsideDown ? deviceMotion.attitude.roll : -deviceMotion.attitude.roll
            let pitchValue = !isUpsideDown ? deviceMotion.attitude.pitch : -deviceMotion.attitude.pitch

            sSelf.yCentreConstraint.constant = sSelf.attitudeValueToConstraintValue(rollValue, centreValue: M_PI_2)
            sSelf.xCentreConstraint.constant = sSelf.startXCentreConstraintConstant + sSelf.attitudeValueToConstraintValue(deviceMotion.attitude.yaw, centreValue: sSelf.centreYawValue!)
            sSelf.earImageView.transform = CGAffineTransformMakeRotation(CGFloat(pitchValue))
        }
    }
    
    func attitudeValueToConstraintValue(currentValue:Double, centreValue:Double) -> CGFloat {
        let minValue = centreValue - 0.3
        let maxValue = centreValue + 0.3
        
        guard currentValue > minValue else { return proportionToConstraintValue(1) }
        guard currentValue < maxValue else { return proportionToConstraintValue(0) }

        let proportion = (maxValue - currentValue) / (maxValue - minValue)
        return proportionToConstraintValue(proportion)
    }
    
    func proportionToConstraintValue(proportion:Double) -> CGFloat {
        let newConstraintValue = (0.5 * maxConstraintValue) - CGFloat(proportion) * maxConstraintValue

        return newConstraintValue
    }
    
    @IBAction func thumbDown(sender: AnyObject) {
        startOtoscope()
    }
    
    @IBAction func thumbUp(sender: AnyObject) {
        stopOtoscope()
    }
    
    @IBAction func thumbUpOutside(sender: AnyObject) {
        stopOtoscope()
    }
    
    func startOtoscope() {
        self.earImageView.hidden = false
        self.holdThumbHereLabel.hidden = true
        self.moveOnLabel.hidden = false
        centreYawValue = nil
        startHandlingAttitudeChanges()
    }
    
    func stopOtoscope() {
        self.earImageView.hidden = true
        self.motionManager.stopDeviceMotionUpdates()
        self.moveOnLabel.hidden = true
        
        self.showAnswers()
    }
    
    func showAnswers() {
        guard let revealViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RevealViewController") as? RevealViewController else { return }

        revealViewController.condition = self.presentedCondition
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let answers = self.presentedCondition.testConditionName
        
        for answerName in answers {
            let action = UIAlertAction(title: answerName, style: .Default) {
                (alert: UIAlertAction!) -> Void in

                let isRightAnswer = answerName == self.presentedCondition.name
                
                revealViewController.isRightAnswer = isRightAnswer
                
                self.presentViewController(revealViewController, animated: true, completion: nil)
            }
            
            optionMenu.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var ottoscopeLeftImageView: UIImageView!
    @IBAction func earSelectionChanged(sender: UISegmentedControl) {
        let isLeft = sender.selectedSegmentIndex == 0
        
        if isLeft {
            self.ottoscopeLeftImageView.transform = CGAffineTransformIdentity
        } else {
            self.ottoscopeLeftImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
}

