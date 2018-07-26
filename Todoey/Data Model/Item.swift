//
//  Item.swift
//  Todoey
//
//  Created by Gilles Poirot on 17/07/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // sera la date courrante au moment de la création
//    @objc dynamic var dataCreated: Date?
    
    // Les Items sont référencés dans la classe Category et pour avoir
    // la relation inverse on utilise la classe LinkingObjects
    // On définit la classe (le type) de la référence avec fromType
    // Le fait que l'on fasse Category.self correspond un peu à utiliser "Category.class"
    // en Java, c'est la façon de récupérer le type (la meta classe en quelque sorte)
    // et le nom de la property dans cette classe qui définit la relation
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
