//
//  Category.swift
//  Todoey
//
//  Created by Gilles Poirot on 17/07/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    // Le type List est une collection définit par Realm
    // A noter aussi qu'il n'est pas nécessaire de mettre @objc
    // et d'ailleurs ce n'est pas possible le compilo râle.
    let items = List<Item>()
}
