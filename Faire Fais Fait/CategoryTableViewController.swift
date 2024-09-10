//
//  CategoryTableViewController.swift
//  Faire Fais Fait
//
//  Created by Seedy on 29/08/2024.
//

import UIKit
import CoreData

class CategoryTableViewController: SwipeTableViewController{
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem){
        //display pop up with text filed to add a new item
        var txtField = UITextField()
        let alert = UIAlertController(title: "Add a new Space", message: "", preferredStyle: .alert)
        alert.addTextField { alterTextField in
            alterTextField.placeholder = "Add new Category"
            txtField = alterTextField
        }
        let alertAction = UIAlertAction(title: "Add", style: .default) { UIAA in
            // TODO: add check if cat is ""/empty
            let newC = Category(context: self.context)
            newC.name = txtField.text!
            self.categories.append(newC)
            self.saveCategory()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.backgroundColor = UIColor(named: "green")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    


    // MARK: - data save and load
    func saveCategory(){
        do{
            try context.save()
        }catch{
            printContent("Error \(error)")
        }
        self.tableView.reloadData()
    }

    func loadCategories(with req: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
           categories = try context.fetch(req)
        }catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexP: IndexPath) {
        //        DELETE
                context.delete(categories[indexP.row])
                categories.remove(at: indexP.row)
        //        DELETE
    }
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! ListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedcategory = categories[indexPath.row]
        }
    }

}
