//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/19/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCanceled(message: String)
    
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate:AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTaskCanceled("Task not added after all.")

    }

    @IBAction func addTaskButtonPressed(sender: UIButton) {
        // recognize when the task is to be added
        // get access to our appDelegate
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = ModelManager.instance.managedObjectContext  //.. because we want to access the managed object context
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
            task.task = taskTextField.text.capitalizedString
        }
        else {
            task.task = taskTextField.text
        }
        task.subtask = subTaskTextField.text
        task.date = dueDatePicker.date
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            task.completed = true
        }
        else {
            task.completed = false
        }
        
        ModelManager.instance.saveContext()  // this saves the stuff!
        
        // lets review evertying in the coredata DB
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("Task Added!")

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
