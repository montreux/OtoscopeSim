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
        return UIScreen.main.bounds.height - ottoscopeImageView.frame.height
    }
    
    override func viewDidLoad() {
        self.earImageView.isHidden = true
        startXCentreConstraintConstant = self.xCentreConstraint.constant
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard (self.shownConditions.count != Conditions.TestSet.count) else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.presentedCondition = self.chooseNextRandomCondition(from:Conditions.TestSet)
        self.shownConditions.append(presentedCondition.name)

        self.setConditionImage(presentedCondition.imageName)
        self.holdThumbHereLabel.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
    
    func setConditionImage(_ imageName:String) {
        self.earImageView.image = UIImage(named: self.presentedCondition.imageName)
    }
    
    func startHandlingAttitudeChanges() {
        guard self.motionManager.isDeviceMotionAvailable else { return }
        
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main) {
            [weak self](deviceMotion:CMDeviceMotion?, error:Error?) -> () in
            
            guard let deviceMotion = deviceMotion, let sSelf = self else { return }
            
            if sSelf.centreYawValue == nil {
                sSelf.centreYawValue = deviceMotion.attitude.yaw
            }
            
            let isUpsideDown = deviceMotion.attitude.roll < 0
            let rollValue = !isUpsideDown ? deviceMotion.attitude.roll : -deviceMotion.attitude.roll
            let pitchValue = !isUpsideDown ? deviceMotion.attitude.pitch : -deviceMotion.attitude.pitch

            sSelf.yCentreConstraint.constant = sSelf.attitudeValueToConstraintValue(rollValue, centreValue: M_PI_2)
            sSelf.xCentreConstraint.constant = sSelf.startXCentreConstraintConstant + sSelf.attitudeValueToConstraintValue(deviceMotion.attitude.yaw, centreValue: sSelf.centreYawValue!)
            sSelf.earImageView.transform = CGAffineTransform(rotationAngle: CGFloat(pitchValue))
        }
    }
    
    func attitudeValueToConstraintValue(_ currentValue:Double, centreValue:Double) -> CGFloat {
        let minValue = centreValue - 0.3
        let maxValue = centreValue + 0.3
        
        guard currentValue > minValue else { return proportionToConstraintValue(1) }
        guard currentValue < maxValue else { return proportionToConstraintValue(0) }

        let proportion = (maxValue - currentValue) / (maxValue - minValue)
        return proportionToConstraintValue(proportion)
    }
    
    func proportionToConstraintValue(_ proportion:Double) -> CGFloat {
        let newConstraintValue = (0.5 * maxConstraintValue) - CGFloat(proportion) * maxConstraintValue

        return newConstraintValue
    }
    
    @IBAction func thumbDown(_ sender: AnyObject) {
        startOtoscope()
    }
    
    @IBAction func thumbUp(_ sender: AnyObject) {
        stopOtoscope()
    }
    
    @IBAction func thumbUpOutside(_ sender: AnyObject) {
        stopOtoscope()
    }
    
    func startOtoscope() {
        self.earImageView.isHidden = false
        self.holdThumbHereLabel.isHidden = true
        self.moveOnLabel.isHidden = false
        centreYawValue = nil
        startHandlingAttitudeChanges()
    }
    
    func stopOtoscope() {
        self.earImageView.isHidden = true
        self.motionManager.stopDeviceMotionUpdates()
        self.moveOnLabel.isHidden = true
        
        self.showAnswers()
    }
    
    func showAnswers() {
        guard let revealViewController = self.storyboard?.instantiateViewController(withIdentifier: "RevealViewController") as? RevealViewController else { return }

        revealViewController.condition = self.presentedCondition
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let answers = self.presentedCondition.testConditionName
        
        for answerName in answers {
            let action = UIAlertAction(title: answerName, style: .default) {
                (alert: UIAlertAction!) -> Void in

                let isRightAnswer = answerName == self.presentedCondition.name
                
                revealViewController.isRightAnswer = isRightAnswer
                
                self.present(revealViewController, animated: true, completion: nil)
            }
            
            optionMenu.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var ottoscopeLeftImageView: UIImageView!
    @IBAction func earSelectionChanged(_ sender: UISegmentedControl) {
        let isLeft = sender.selectedSegmentIndex == 0
        
        if isLeft {
            self.ottoscopeLeftImageView.transform = CGAffineTransform.identity
        } else {
            self.ottoscopeLeftImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }
    }
}

