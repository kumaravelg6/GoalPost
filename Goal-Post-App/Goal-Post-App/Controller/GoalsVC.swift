//
//  GoalsVC.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/26/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import UIKit
import CoreData //core data to save persistent storage on device

let appDelegate = UIApplication.shared.delegate as? AppDelegate //we can now access the appdelegate from anywhere in our project



class GoalsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoBtnView: UIView!
    @IBOutlet weak var goalRemovenotif: UIView!
    
    
    var goals: [Goal] = [] //open array, we use this array for the fetch request since it returns an array of our data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self //conform to these protocols/ delegate & dataSource
        tableView.dataSource = self //so the app can know what you're talking about and whats the data source
    }
    
    

    override func viewWillAppear(_ animated: Bool) { //view will appear is called everytime the view appears, so its perfect for our fetch request
        super.viewWillAppear(animated)
        fetchCoreDataObjects() //call fetch data
        tableView.reloadData() //reload the data after we fetch no matter what
    }
    
    func fetchCoreDataObjects() { //to fetch data
        self.fetch { (complete) in //call fetch
            if complete {
                if goals.count >= 1 { //if there is 1 result or more in our data, show the result
                    tableView.isHidden = false //show the table view
                    
                } else {
                    tableView.isHidden = true //if there are no results, don't show the tableView
                }
            }
        }
    }
    
    //IBActions
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return } //to create identifier to move between views
        presentDetail(viewControllerToPresent: createGoalVC) //to present the view controller using the extension animation
    }
    
    @IBAction func noUndoBtnPressed(_ sender: Any) {
        undoBtnView.isHidden = true
        goalRemovenotif.isHidden = false
        goalRemovenotif.alpha = 0.8
        UIView.animate(withDuration: 0.5, delay: 0.5, options:[], animations: {
            self.goalRemovenotif.alpha = 0
        }) { (finished) in
            self.goalRemovenotif.isHidden = true
        }
        
    }
    
    @IBAction func yesUndoBtnPressed(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return } //hold that context
        managedContext.undoManager?.undo()
        undoBtnView.isHidden = true
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return goals.count //the amount of items in the array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }  //create a cell and then present it
        
        let goal = goals[indexPath.row] //pull out the items in the row at the index path
        
        cell.configureCell(goal: goal) //pass in the configure cell to present the cell with the custom data: from 'GoalCell'
        return cell //returns cell with the data
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //to edit tableView
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none //none bcuz we are going to have a custom editing style
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { //two actions: delete, and add progress
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in //destructive is used to destroy
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects() //call fetch, to update data
            tableView.deleteRows(at: [indexPath], with: .automatic) //remove a certain row that we deleted, and animate it closing; automatic is a type of animation
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath) //call our func to add progress
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) //color of the delete button
        addAction.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        return [deleteAction, addAction] //return the actions
    }
}


extension GoalsVC {
    
    func setProgress(atIndexPath indexPath: IndexPath ) { //set the progress of our goal
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return } //hold that context

        let chosenGoal = goals[indexPath.row] //pull out the index path
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue { //if the progress is the less than the goal Value, add +1 to the progress.
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return //if its more than goalValue, return out of this function
        }
        
        do { //save it into our core data; //save the managed context to update everything
            try managedContext.save()
            print("successfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
        
    }
    
    
    func removeGoal(atIndexPath indexPath: IndexPath) { //to remove a goal, we want to remove it from the core data
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.undoManager = UndoManager()
        
        managedContext.delete(goals[indexPath.row]) //delete the managed context of goals(type Goal), and pull out the index path.row in the array to delete the right object
        
        do { //save the managed context to update everything
           try managedContext.save()
            self.undoBtnView.isHidden = false
            print("successfully removed Goal")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
        
        
    }
    
    func fetch(completion: (_ complete: Bool) ->()) { //func to fetch data from persistant container
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return } //hold that context
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal") //trying to fetch items from the entity "Goal"
        
        do { //do catch block
            goals = try managedContext.fetch(fetchRequest) as! [Goal] //throws; call the fetch request, returns an array of all of the results we ask for.
            print("successfully fetched data")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
    }
}















