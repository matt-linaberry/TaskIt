//
//  TaskModel.swift
//  TaskIt
//
//  Created by Matthew Linaberry on 2/28/15.
//  Copyright (c) 2015 Matthew Linaberry. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)  // This lets us use this class in an objective c app.
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
