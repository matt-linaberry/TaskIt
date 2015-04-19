//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/14/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import UIKit

@objc protocol TaskDetailViewControllerDelegate {
    optional func taskDetailEdited()
}

class TaskDetailViewController: UIViewController {

    var detailTaskModel: TaskModel!    
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var taskTextField: UITextField!
    
    var delegate:TaskDetailViewControllerDelegate?  // this will be an optional too
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // make the current view controller disappear!
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)

        // Do any additional setup after loading the view.
        self.taskTextField.text = detailTaskModel.task
        self.subTaskTextField.text = detailTaskModel.subtask
        self.dueDatePicker.date = detailTaskModel.date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonPressed(sender: AnyObject) {
        detailTaskModel.task = taskTextField.text
        detailTaskModel.subtask = subTaskTextField.text
        detailTaskModel.date = dueDatePicker.date
        detailTaskModel.completed = detailTaskModel.completed
        
        ModelManager.instance.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.taskDetailEdited!()
    }
}
