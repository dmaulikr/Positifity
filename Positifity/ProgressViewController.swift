//
//  ProgressViewController.swift
//  Positifity
//
//  Created by Dan Isacson on 18/10/14.
//  Copyright (c) 2014 dna. All rights reserved.
//

import UIKit
import HealthKit

class ProgressViewController: UIViewController {

    @IBOutlet var currentWeight: UILabel!
    @IBOutlet var goalWeightLabel: UILabel!
    @IBOutlet var circle: SAMultisectorControl!
    
    var goalWeight: Double = 0
   var goalPercentage: Double = 0
    
    var weightLoss: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer
        setupCircle()
        loadWeightText()
        
        //timer for changing goalweight/progress %
        NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "transition", userInfo: nil, repeats: true)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCircle(){
        //nollställ
        self.circle.removeAllSectors()
        
        var startWeight = NSUserDefaults.standardUserDefaults().doubleForKey("startWeight")
        var goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey("goal")
        var currentWeight = NSUserDefaults.standardUserDefaults().doubleForKey("weight")
        
        //if losing weight or gaining
        weightLoss = (startWeight - goalWeight >= 0)
        self.circle.addTarget(self, action: "multisectorValueChanged", forControlEvents: UIControlEvents.ValueChanged)
        self.circle.userInteractionEnabled = false
        
        var sector : SAMultisectorSector
        if(weightLoss){
            if(startWeight <= currentWeight){
                startWeight = currentWeight + 0.01  //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: -startWeight, maxValue: -goalWeight)
            sector.endValue = -currentWeight
            sector.startValue = -startWeight
        }else{
            if(startWeight >= currentWeight){
                startWeight = currentWeight + 0.01 //fulhack för sector..
            }
            sector = SAMultisectorSector(color: UIColor(hexString: "009dd0"), minValue: startWeight, maxValue: goalWeight)
            sector.endValue = currentWeight
            sector.startValue = startWeight
        }

        self.circle.addSector(sector)
        
    }
    
    func multisectorValueChanged(){
        self.updateDataView()
    }
    
    func updateDataView(){
        
    }

    func loadWeightText(){
       goalWeight = NSUserDefaults.standardUserDefaults().doubleForKey("goal")
        var startWeight = NSUserDefaults.standardUserDefaults().doubleForKey("startWeight")
        var currentWeight = NSUserDefaults.standardUserDefaults().doubleForKey("weight")
        if(weightLoss){
            if(startWeight <= currentWeight){
                goalPercentage = 0
            }else{
                goalPercentage = (startWeight - currentWeight)/(startWeight - goalWeight) * 100
            }
        }else{
            if(startWeight >= currentWeight){
                goalPercentage = 0
            }
            else{
                goalPercentage = (currentWeight - startWeight)/(goalWeight - startWeight) * 100
            }
        }
        
        goalWeightLabel.text = NSUserDefaults.standardUserDefaults().doubleForKey("goal").description
       /* if let wu = NSUserDefaults.standardUserDefaults().stringForKey("weightUnit") {
            if let hu = NSUserDefaults.standardUserDefaults().stringForKey("heightUnit") {
                currentWeight.text = NSUserDefaults.standardUserDefaults().doubleForKey("weight").description + wu + " " + NSUserDefaults.standardUserDefaults().doubleForKey("height").description + hu
            }
        }*/
    }
    
    
    func transition(){
        let anim: CATransition = CATransition()
        anim.duration = 1.2
        anim.type = kCATransitionFade
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.removedOnCompletion = false
        goalWeightLabel.layer.addAnimation(anim, forKey: "changeTextTransition")
        if(self.goalWeightLabel.text == goalWeight.description){
            self.goalWeightLabel.text = goalPercentage.description
        }
        else{
            self.goalWeightLabel.text = goalWeight.description
        }
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        self.setupCircle()
        loadWeightText()
        println(segue.identifier)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
