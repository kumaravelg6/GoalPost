//
//  CreateGoalVC.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/28/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    
    //IBOutlets
    @IBOutlet weak var goalTxtView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var LongTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm //setting it equal to short term from the beginning
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.bindToKeyboard() //if you call this, when keyboard goes up, nxt button goes up with it as well
        shortTermBtn.setSelectedColor() //sets the button to be dark green
        LongTermBtn.setDeselctedColor() //sets btn to be light green
        goalTxtView.delegate = self //delegate
    }
    
    //IBActions
 
    @IBAction func shortTermBtnWasPressed(_ sender: Any) { //switch btn colors if this one is pressed
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        LongTermBtn.setDeselctedColor()
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) { //switch btn colors if this one is pressed
        goalType = .longTerm
        shortTermBtn.setDeselctedColor()
        LongTermBtn.setSelectedColor()
    }
    
    
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if goalTxtView.text != "" && goalTxtView.text != "What Is Your Goal?" { //make sure their is something typed into the txtField
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC else { return }
            finishGoalVC.initData(description: goalTxtView.text!, type: goalType) //initializes data that was passed into this vc, to be passed into the next one
            presentingViewController?.presentSecondaryDetail(viewControllerToPresent: finishGoalVC) //dismiss the old animation and VC, to present the next view controller(with custom animations, and now it should have data initialized already)
        }
    }
    

    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail() //to dismiss it with the specific animation we wanted
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTxtView.text = "" //clear previous txt
        goalTxtView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //color black
    }
}
