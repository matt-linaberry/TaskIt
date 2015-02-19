//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/14/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var detailTaskModel: TaskModel!
    var mainVC: ViewController!
    
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // make the current view controller disappear!
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTextField.text = detailTaskModel.task
        self.subTaskTextField.text = detailTaskModel.subTask
        self.dueDatePicker.date = detailTaskModel.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonPressed(sender: AnyObject) {
        var task = TaskModel(task: taskTextField.text, subTask: subTaskTextField.text, date: dueDatePicker.date)
        
        mainVC.taskArray[mainVC.tableView.indexPathForSelectedRow()!.row] = task
        self.navigationController?.popViewControllerAnimated(true)
    }
}
