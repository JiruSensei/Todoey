//
//  ViewController.swift
//  Todoey
//
//  Created by Gilles Poirot on 15/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit
import CoreData // en fait ça marchait sans!!!

// Le fait d'hériter de UITableViewController fait
// qu'on n'a plus besoin de créer le TableView et
// de s'enregistrer en tant que delegate et datasource
// contrairement à ce qu'on avait fait dans l'application
//
class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        // Attention quand on utilise pas de paramètre il n'y a pas les paraenthèses
        didSet {
            loadItems()
        }
    }
    
    // On récupère le context de AppDelegate à partir du singleton UIApplication.shared et de sa propriété delegate
    // Le PersistentContainer c'est la base de donnée
    // Le context c'est le cahe (buffer) en mémoire sur lequel on travail
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Juste pour avoir l'information où se trouve nos data
        // mais on ne récupère plus .first...
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

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
        
        // Pour effacer la cellule il faut supprimer l'item du tableau
        // mais avant il faut la supprimer du context explicitement
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // Il faut réappeler le callback cellForRow (datasource- pour pouvoir
        // positionner correctement les checkmark et c'est fait dans saveItems()
        self.saveItems()
        
        // Juste pour rendre l'affichage plus sympa
        // Quand on sélectionne la cell elle prend une autre couleur
        // mais seulement un instant (flash)
        // et retourne ensuite à la couleur originale
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add Button Add
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // On crée un PopUp pour pouvoir entrer le text du nouveau Item
        let alert = UIAlertController(title: "Add new Item to the Todo List", message: "", preferredStyle: .alert)
        
        // Le handler qui sera exécuté (tout du moins la clsure)
        // quand on presse le bouton "Add Item" dans le Popup
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print(textField.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
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
    
    //MARK: - Model Manipulation methods
    
    // Notre méthode pour aller enregistrer les items dans la plist en utilisant
    // PropertyListEncoder
    func saveItems() {
        // On va encoder ensuite notre array d'item avec cet encoder
        // WARNING: j'ai été obligé d'ajouter Item : Encodable car ça ne compilait pas
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // et on reload pour le faire apparaitre autrement ça ne marche pas
        tableView.reloadData()
    }
    
    // Suite à la refactorisation on utilise, et c'est la première fois
    // un paramètre externe
    // Int"ressant également l'usage d'une valeur par défaut qui est faite
    // par un appel de méthode
    // Cette valeur par défaut est on recharge la liste à partir de la base
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // La façon de faire pour créer la requête. Ce qui est important c'est
        // d'indiquer Item c'est à dire le type d'éléments qui sera retournée
        // par la méthode fetch auquel on passe la requête.

        // On ne veut retourner que les élément appartenant à la catégorie sélectionnée
        // faire attention que on fait le "select" sur les attribut de la classe Item, donc
        // parentCategory et non sur la var de la classe VC qui est selectedCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        // On compbine les deux predicate potentiels (il peut y avoir en paramètre le predicate
        // de la searchBar)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        }
        else {
            request.predicate = categoryPredicate
        }

        do {
            // Donc ici on récupère un Array de Item, pas besoin de cast
            print("on essaie de faire un fetch pour la categorie \(selectedCategory!.name!)")
            itemArray = try context.fetch(request)

        } catch {
            print ("Erreur durant le fetch des item de la categorie \(selectedCategory!.name!) error:\(error)")
        }
        
        // et on réaffiche
        tableView.reloadData()
    }
    

}

//MARK: - Extension UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Comme d'hab on crée une requête NSFetchRequest avec
        // le type d'élément qu'on veut récupérer, ici Item, qui sera retourné
        // dans un Array
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // On crée le Predicate, sorte de requête JPQL
        // A noter que "title" est un attribut de la classe Item
        // Le [cd] est là pour supprimer le Case Sensitive (c) et diacretic (d) les accents
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
        
        // Maintenant on va trier les données retournées à l'aide d'un NSSortDescriptor
        // Il existe plusieurs constructeur, ici on utilise celui avec une String par
        // laquelle on indique la propriété utilisée pour le trie et un booléen pour le sens
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // On le positionne avec un Array car c'est un Array qui est attendu
        request.sortDescriptors = [sortDescriptor]

        // On execute la requête (comme précédemment)
        loadItems(with: request, predicate: searchPredicate)
        
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

