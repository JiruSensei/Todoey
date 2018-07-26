//
//  ViewController.swift
//  Todoey
//
//  Created by Gilles Poirot on 15/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit
import RealmSwift

// Le fait d'hériter de UITableViewController fait
// qu'on n'a plus besoin de créer le TableView et
// de s'enregistrer en tant que delegate et datasource
// contrairement à ce qu'on avait fait dans l'application
//
class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        // Attention quand on utilise pas de paramètre il n'y a pas les paraenthèses
        didSet {
            loadItems()
        }
    }

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
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No item added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // MARK - Tableview Delegate Methods

    // La méthode appelée quand on sélectionne une cellule (rangée) dans la liste
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // On modifie le done de l'élément sélectionné
        // Comme Ittem est une classe je pense que c'est une référence et du coup l'élément
        // dans la liste Results<Item> est modifié
        if let item = todoItems?[indexPath.row] {
            do {
                // Ce qui est vraiment intéressant avec Realm c'est qu'ici on fait un Update
                // et pourtant aucune action explicite de save est faite on fait simplement
                // toute les opération dans un bloc realm.write() {}
                try realm.write {
                    // On pourrait faire un delete (D de CRUD) en faisant simplement
                    // realm.delete(item)
                    item.done = !item.done
                }
            }
            catch {
                print("Erreur saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add Button Add
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
         //On crée un PopUp pour pouvoir entrer le text du nouveau Item
        let alert = UIAlertController(title: "Add new Item to the Todo List", message: "", preferredStyle: .alert)

        // Le handler qui sera exécuté (tout du moins la clsure)
        // quand on presse le bouton "Add Item" dans le Popup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textField.text!)

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
//                        newItem.dataCreated = Date()
                        // plutôt que de positionner le parentCategory on enregistre l'item
                        // dans la liste des items de currentCategory
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item \(error)")
                }
            }
            
            // et on reload pour le faire apparaitre autrement ça ne marche pas
            self.tableView.reloadData()
        }
        
         // On ajoute le TextField dans l'alert qui nous permettera
         // d'entrée le titre du nouvel item
        alert.addTextField { (alertTextfield) in
            // Le placeholder est le texte grisé qui apparait dans le textfield
            // par défaut
            alertTextfield.placeholder = "Item?"
            // Si on ne sauve pas cette référence alors
            // elle est perdu à la sortie de la closure
            textField = alertTextfield
        }
        
         // On enregistre l'action dans l'alert
        alert.addAction(action)

        // On affiche le Popu avec la fonction present()
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation methods
    
    // Notre méthode pour aller enregistrer les items dans la plist en utilisant
    // PropertyListEncoder
    func saveItems() {
        // On va encoder ensuite notre array d'item avec cet encoder
        // WARNING: j'ai été obligé d'ajouter Item : Encodable car ça ne compilait pas
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
        // et on reload pour le faire apparaitre autrement ça ne marche pas
//        tableView.reloadData()
    }
    
    func loadItems() {

        // On récupère le lien items de la category sélectionnée
        // Et on le trie de façon ascendante.
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        // et on réaffiche
        tableView.reloadData()
    }
    

}

//MARK: - Extension UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Avec Realm on fait le filtrage directement sur le tableau (liste) en mémoire
        // ce dernier étant map sur la base.
        // A noter que l'argument utilise toujours NSPredicate ou son language de query (comme ici)
        // Par contre pour le sort il suffit d'appeler une fonction chainée
        todoItems = todoItems?
            .filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
     
    }
    
    // On met cette delegate method pour pouvoir revenir à la liste une fois
    // la recherche terminée.
    // En fait cette méthode est appelée à chaque fois que l'on tape de nouveau caractère
    // mais également quand on en supprime (ce qui nous intéresse ici)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // Par défaut c'est une recharge de la base qui est faite
            print("recharge la liste car search est vide")
            loadItems()
            
            DispatchQueue.main.async() {
                // Pour ne plus être l'objet qui reçoit les input (curseur clignotant)
                // Et aussi faire disparaiter le clavier
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

