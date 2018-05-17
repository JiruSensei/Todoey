//
//  ViewController.swift
//  Todoey
//
//  Created by Gilles Poirot on 15/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit

// Le fait d'hériter de UITableViewController fait
// qu'on n'a plus besoin de créer le TableView et
// de s'enregistrer en tant que delegate et datasource
// contrairement à ce qu'on avait fait dans l'application
//
class TodoListViewController: UITableViewController {

    let itemArray = ["Noter ratrappage", "transcrire IGN", "rdv kiné", "aller dentiste 12h30", "T° SFR"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Le nom de l'identifier est celui que l'on a positionné manuellement
        // et que l'on peut voire dans Document
        // (Pour le moment on n'a pas encore créé de classe de ce nom)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Intéressant de noter que indexPath est une classe et pas seulement un entier
        // Il faut donc récupérer la valeur de l'index
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Le concept d'accessory pour ajouter une petite icone, ici une check
        let accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType
        switch  accessoryType {
            case .checkmark?: tableView.cellForRow(at: indexPath)?.accessoryType = .none
            default: tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        
        // Juste pour rendre l'affichage plus sympa
        // Quand on sélectionne la cell elle prend une autre couleur mais seulement un instant (flash)
        // et retourne ensuite à la couleur originale
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

