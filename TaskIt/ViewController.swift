//
//  ViewController.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/12/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        fetchedResultsController  = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)  // get the stuff!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iCloudUpdated"), name: "coreDataUpdated", object: nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // prepare to move to the detail task view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as! TaskModel
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC:AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            addTaskVC.delegate = self
            
        }
    }
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask:TaskModel = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.taskLabel.text = thisTask.task
        cell.subtaskLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        return cell
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)  //sender passes some information
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (fetchedResultsController.sections?.count == 1) {
            // if theres one section, what should we do?
            // then is this a completed or to do section?
            let fetchedObjects = fetchedResultsController.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as! TaskModel
            if (testTask.completed == true) {
                return "Completed"
            }
            else {
                return "To Do"
            }
        }
        else {
            if (section == 0) {
                return "To Do"
            }
            else {
                return "Completed"
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    // immediately adds swipe functionality per row.
    // mark the selected task as complete.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        if (thisTask.completed == true) {
            thisTask.completed = false
        }
        else {
            thisTask.completed = true
        }
        ModelManager.instance.saveContext()
        
    }
    // NSFetchedControllerDelegate method!
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // Helpers
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        // add the property
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: ModelManager.instance.managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    // TaskDetailViewControllerDelegate method
    func taskDetailEdited() {
        showAlert()
    }
    
    func showAlert(message: String = "Congratulations") {
        var alert = UIAlertController(title: "Change made!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // AddTaskViewControllerDelegate method
    
    func addTask(message: String) {
        showAlert(message: message)
    }
    
    func addTaskCanceled(message: String) {
        showAlert(message: message)
    }
    // iCloud methods!
    func iCloudUpdated() {
        tableView.reloadData()
    }
}

