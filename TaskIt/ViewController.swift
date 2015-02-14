//
//  ViewController.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/12/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var taskArray:[TaskModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let task1 = TaskModel(task: "Study French", subTask: "Verbs", date: "1/14/2015")
        let task2 = TaskModel(task: "Eat Dinner", subTask: "Burgers", date: "1/14/2015")
        let task3 = TaskModel(task: "Gym", subTask: "Leg Day", date: "1/14/2014")
        
        taskArray = [task1, task2, task3]
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask:TaskModel = taskArray[indexPath.row]
        
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        cell.taskLabel.text = thisTask.task
        cell.subtaskLabel.text = thisTask.subTask
        cell.dateLabel.text = thisTask.date
        return cell
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}

