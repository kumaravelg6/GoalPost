//
//  FinishGoalVC.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/28/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import UIKit
import CoreData



class FinishGoalVC: UIViewController, UITextFieldDelegate {

    
    
    
    //outlets
    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTxtField: UITextField!
    
    var goalDescription: String! //to hold data of the models
    var goalType: GoalType!
    
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
        pointsTxtField.delegate = self
    }
    
    //actions
    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        if pointsTxtField.text != "" { //points txt field can't be empty
            self.save { (complete) in
                if complete { //if the saving is complete
                    dismiss(animated: true, completion: nil) //dismiss all the way to the main view controller
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pointsTxtField.text = ""
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail() //go back to other VC
    }
    
    func save(completion: (_ finished: Bool) -> ()) { //to save data into our core data model.
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return } //managedContext so it knows where its saving the data
        let goal = Goal(context: managedContext) //an instance of goal and a managedContext so it knows where its saving the data
        
        //this is the storage model
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue //rawvalue is the string
        goal.goalCompletionValue = Int32(pointsTxtField.text!)! //has to be of type int32
        goal.goalProgress = Int32(0) //we're starting at 0 progress
        
        
        //save it in persistent storage
        do { //neeeds a do, catch block bcuz .save is "throws"
            try managedContext.save() //we have to try
            print("saved info into core data")
            completion(true) //if works, it's true
        } catch { //if it doesn't work, catch the error
            debugPrint("could not save: \(error.localizedDescription)")
            completion(false)
        }
        
        
    }
    
    
}











