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

    var itemArray = [Item]() //["Noter ratrappage", "transcrire IGN", "rdv kiné", "aller dentiste 12h30", "T° SFR"]
    // On crée un fichier en utilisant F
    // ileManager qui est une interface pour le système de fichier
    // on récupère dessus le singleton "default", instance de FileManager
    // Qui contient un certain nombre d'url organisée par directory et domainMask (le lieu dans le directory)
    // Comme ça retourne une collection on prend le premier élément
    // Ensuite, avec append...() on crée notre propre plist file plutôt que d'utiliser UserDefaults
    var dataFilePath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // On crée ou ouvre un espace de storage (un fichier plist)
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
//        itemArray.append(Item(title: "Aller EFREI"))
//        itemArray.append(Item(title: "Faire Data Model"))
//        itemArray.append(Item(title: "aller Bonita"))
        
        loadItems()
        
        // Exemple de code où on utilisait le UserDefault pour sauvegarder la liste des itels
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }

    }
    
    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Le nom de l'identifier est celui que l'on a positionné manuellement
        // et que l'on peut voire dans Document
        // (Pour le moment on n'a pas encore créé de classe de ce nom)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Intéressant de noter que indexPath est une classe et pas seulement un entier
        // Il faut donc récupérer la valeur de l'index
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Il faut réappeler le callback cellForRow (datasource- pour pouvoir
        // positionner correctement les checkmark et c'est fait dans saveItems()
        self.saveItems()
        
        // Juste pour rendre l'affichage plus sympa
        // Quand on sélectionne la cell elle prend une autre couleur
        // mais seulement un instant (flash)
        // et retourne ensuite à la couleur originale
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Bar Button Add
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // On crée un PopUp pour pouvoir entrer le text du nouveau Item
        let alert = UIAlertController(title: "Add new Item to the Todo List", message: "", preferredStyle: .alert)
        
        // Le handler qui sera exécuté (tout du moins la clsure)
        // quand on presse le bouton "Add Item" dans le Popup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textField.text!)
            // On ajoute ici le nouvel item dans la liste
            let newItem = Item(title: textField.text!)
            self.itemArray.append(newItem)
            
            // On sauvegarde le nouveau Array en base locale
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")            
            self.saveItems()
            
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
        
        // Onenregistre l'action dans l'alert
        alert.addAction(action)
        
        // On affiche le Popu avec la fonction present()
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation methods
    
    // Notre méthode pour aller enregistrer les items dans la plist en utilisant
    // PropertyListEncoder
    func saveItems() {
        // On crée d'abord un encoder (qui semble permettre de gérer des fichiers plist)
        let encoder = PropertyListEncoder()
        
        // On va encoder ensuite notre array d'item avec cet encoder
        // WARNING: j'ai été obligé d'ajouter Item : Encodable car ça ne compilait pas
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            // A noter que "error" est une variable implicite
            print("something wrong in encoding plist, \(error)")
        }
        // et on reload pour le faire apparaitre autrement ça ne marche pas
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            // Le pendant de la méthode saveItems, cette fois-ci on crée un Decoder pour PList
            let decoder = PropertyListDecoder()
            do {
                // Il faut indiquer le type que l'on veut décoder.
                // J'ai du mal à comprendre ce .self
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding, \(error)")
            }
            
        }
    }
}

