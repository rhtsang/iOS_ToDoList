//
//  Category.swift
//  To Do
//
//  Created by Raymond Tsang on 9/23/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var categoryName : String = ""
    let items = List<Task>()
}
