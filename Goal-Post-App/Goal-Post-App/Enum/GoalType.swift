//
//  GoalType.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/27/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import Foundation

//enum to deal with the type of goal/// Short term vs. long term goal. lets the user choose which type
enum GoalType: String { //makes it of type string
    case longTerm = "Long Term" //presents it into textual form
    case shortTerm = "Short Term" //core data needs it to be a string
}
