//
//  Task.swift
//  To Do
//
//  Created by Raymond Tsang on 9/23/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import Foundation
import RealmSwift

class Task : Object {
    @objc dynamic var taskName : String = ""
    @objc dynamic var taskCompleted : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
