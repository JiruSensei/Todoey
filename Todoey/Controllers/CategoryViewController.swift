//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gilles Poirot on 25/06/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    // Notre collection de Categories
    var categories = [Category]()
    
    // Le contexte
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()

    }
    
    //============================================================
    //MARK: - Datasource
    // Pour pouvoir afficher nos catégorie présentent dans le persistence container
    // on doit implémenter ce callback "cellForRowAt"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Le nom de l'identifier est celui que l'on a positionné manuellement
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // Intéressant de noter que indexPath est une classe et pas seulement un entier
        // Il faut donc récupérer la valeur de l'index
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // Le callback qui indique le nombre de categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    //============================================================
    //MARK: - TableView delegate methods
    // Les callbacks qu'on enregistre quand on joue avec la tableView
    
    // gère ce qu'il se passe quand on clic une cell dans la liste des catégories
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected category is ")
        print(categories[indexPath.row].name!)
        
        // Ce que l'on veut c'est donc aller dans l'écran (TableView) de cette catégorie
        // pour ça on active la navigation "performSegue" en utilisant le "identifier"
        // du segue entre Categorie et Items VC
        performSegue(withIdentifier: "gotoItems", sender: self)
    
    }
    
    // Il faut préparer ce qui sera afficher et opur cela on utilise la fonction prepare()
    // qui sera automatiquement appelée avant segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // On sauvegarde une référence surt le VC destination
        let destinationVC = segue.destination as! TodoListViewController
        
        // On récupère l'index dde la cell sélectionnée
        // le if est ici le cas généraale où potentiellement aucune cell ne serait
        // sélectionnée mais dans notre cas en fait on est sûre
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //============================================================
    //MARK: - Data Manipulation (CRUD)
    //On appel just la méthode save() sur le contexte
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving categories \(error)")
        }
        // et on reload pour le faire apparaitre autrement ça ne marche pas
        tableView.reloadData()
    }
    
    //On récupère la request et appel la méthode fetch()
    //IMPORTANT - Le type paramétré est le type qui sera retourné par la requête
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            // Donc ici on récupère un Array de Category, pas besoin de cast
            categories = try context.fetch(request)
        } catch {
            print ("Erreur durant le fetch des categories \(error)")
        }
        // et on réaffiche
        tableView.reloadData()
    }

    //============================================================
    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // On crée un PopUp pour pouvoir entrer le text du nouveau Item
        let alert = UIAlertController(title: "Add new Category to the Todo List", message: "", preferredStyle: .alert)
        
        // Cet handler qui sera exécuté (tout du moins la closure)
        // quand on presse le bouton "Add Item" dans le Popup
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        // On ajoute le TextField dans l'alert qui nous permettera
        // d'entrée le titre du nouvel Category
        alert.addTextField { (alertTextfield) in
            // Le placeholder est le texte grisé qui apparait dans le textfield ar défaut
            alertTextfield.placeholder = "Category?"
            // Si on ne sauve pas cette référence alors
            // elle est perdu à la sortie de la closure
            textField = alertTextfield
        }
        
        // On enregistre l'action dans l'alert
        alert.addAction(action)
        
        // On affiche le Popup avec la fonction present()
        present(alert, animated: true, completion: nil)
    }
    
}
