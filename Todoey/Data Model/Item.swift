//
//  TodoItem.swift
//  Todoey
//
//  Created by Gilles Poirot on 28/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool  = false
    
    init(title: String) {
        self.title = title
    }

}
