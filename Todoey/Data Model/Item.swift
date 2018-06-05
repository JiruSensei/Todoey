//
//  TodoItem.swift
//  Todoey
//
//  Created by Gilles Poirot on 28/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import Foundation

// Le fait d'être conform à Encodable permet d'ête transformé en plist ou encore en JSON
// Pour ce faire il faut que tous les attribnuts/properties soit de type "Standard"
// On peut remplacer Encodable et Decodable simplement par Codable
class Item : Codable { //Encodable, Decodable{
    var title: String = ""
    var done: Bool  = false
    
    init(title: String) {
        self.title = title
    }

}
