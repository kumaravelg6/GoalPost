//
//  GoalCell.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/26/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    
    func configureCell(goal: Goal) { //when we init these cells the data will input into the cells
        self.goalDescriptionLbl.text = goal.goalDescription
        self.goalTypeLbl.text = goal.goalType
        self.goalProgressLbl.text = String(describing: goal.goalProgress) //converts int into string, the textual value, not the numerical value
        
        
        if goal.goalProgress == goal.goalCompletionValue { //if our progress is the same as the completion value, the completionView will show
            self.completionView.isHidden = false
        } else {
            self.completionView.isHidden = true //if its not complete, hide
        }
    }
    
}
