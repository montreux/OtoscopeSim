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

    @IBOutlet weak var ottoscopeImageView: UIImageView!
    @IBOutlet weak var earImageView: UIImageView!
    @IBOutlet weak var xCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var yCentreConstraint: NSLayoutConstraint!
    @IBOutlet weak var holdThumbHereLabel: UILabel!
    @IBOutlet weak var moveOnLabel: UILabel!
    @IBOutlet weak var answersLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var answersTableView: UITableView!
    
    let motionManager = CMMotionManager()
    var centreYawValue:Double?
    var startXCentreConstraintConstant:CGFloat = 0
    
    var maxConstraintValue:CGFloat {
        return UIScreen.mainScreen().bounds.height - ottoscopeImageView.frame.height
    }
    
    override func viewDidLoad() {
        self.earImageView.hidden = true
        self.answersLeftConstraint.constant = -self.answersTableView.frame.width
        startXCentreConstraintConstant = self.xCentreConstraint.constant
        
        self.answersTableView.dataSource = self
        self.answersTableView.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func startHandlingAttitudeChanges() {
        guard self.motionManager.deviceMotionAvailable else { return }
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
            [weak self](deviceMotion:CMDeviceMotion?, error:NSError?) -> Void in
            
            guard let deviceMotion = deviceMotion, let sSelf = self else { return }
            
            if sSelf.centreYawValue == nil {
                sSelf.centreYawValue = deviceMotion.attitude.yaw
            }
            
            sSelf.yCentreConstraint.constant = sSelf.attitudeValueToConstraintValue(deviceMotion.attitude.roll, centreValue: M_PI_2)
            sSelf.xCentreConstraint.constant = sSelf.startXCentreConstraintConstant + sSelf.attitudeValueToConstraintValue(deviceMotion.attitude.yaw, centreValue: sSelf.centreYawValue!)
            sSelf.earImageView.transform = CGAffineTransformMakeRotation(CGFloat(deviceMotion.attitude.pitch))
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
        
        self.view.layer.removeAllAnimations()
        
        UIView.animateWithDuration(0.3) {
            self.answersLeftConstraint.constant = -self.answersTableView.frame.width
            self.view.layoutIfNeeded()
        }
    }
    
    func stopOtoscope() {
        self.earImageView.hidden = true
        self.motionManager.stopDeviceMotionUpdates()
        self.moveOnLabel.hidden = true
        
        self.view.layer.removeAllAnimations()
        
        UIView.animateWithDuration(0.3) {
            self.answersLeftConstraint.constant = 0
            self.view.layoutIfNeeded()
        }

    }
}

extension SimulatorViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AnswerCellView
        
        switch indexPath.row {
        case 0:
            cell.answerLabel.text = "Normal"
            break
        case 1:
            cell.answerLabel.text = "Glomus tumour"
            break
        case 2:
            cell.answerLabel.text = "Haemotympanum"
            break
        case 3:
            cell.answerLabel.text = "Glomus tumour"
            break
        case 4:
            cell.answerLabel.text = "Acute otitis media"
            break
        default:
            cell.answerLabel.text = "Unknown"
        }
        
        return cell
    }
}

extension SimulatorViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let revealViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RevealViewController") as? RevealViewController else { return }
        
        let isRightAnswer = (indexPath.row == 4)
        revealViewController.isRightAnswer = isRightAnswer

        self.presentViewController(revealViewController, animated: true, completion: nil)
    }
}
