//
//  ViewController.swift
//  Faire Fais Fait
//
//  Created by Seedy on 21/08/2024.
//

import UIKit
import CoreData

class ListViewController: SwipeTableViewController{
    
    var selectedcategory: Category?{
        didSet{
            loadItems()
        }
    }
    var items = [Item]()
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //  loadItems()
    }
    
    
    @IBAction func addItemBarButton(_ sender: UIBarButtonItem){
        //display pop up with text filed to add a new item
        var txtField = UITextField()
        let alert = UIAlertController(title: "Add a new item", message: "", preferredStyle: .alert)
        alert.addTextField { alterTextField in
            alterTextField.placeholder = "Add new item"
            txtField = alterTextField
        }
        let alertAction = UIAlertAction(title: "Add", style: .default) { UIAA in
            // after "Add" button is clicked
            // TODO: add check if item is ""/empty
            let newItem = Item(context: self.context)
            newItem.title = txtField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedcategory
            self.items.append(newItem)
            self.saveItems()
            
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    override func updateModel(at indexP: IndexPath) {
        //        DELETE
                context.delete(items[indexP.row])
                items.remove(at: indexP.row)
        //        DELETE
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    // clicking on a table view item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        items[indexPath.row].done = !items[indexPath.row].done
//        DELETE
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
//        DELETE
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: data save and load
    func saveItems(){
        do{
            try context.save()
        }catch{
            printContent("Error \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(with req: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedcategory!.name!)
        if let additionalPredicates = predicate{
            req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, additionalPredicates])
        }else{
            req.predicate = catPredicate
        }
        
        do{
           items = try context.fetch(req)
        }catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }

}


extension ListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let req: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        req.sortDescriptors = [sortDescriptor]
        loadItems(with: req, predicate: predicate)
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
