//
//  LandmarkViewController.swift
//  Travel App
//
//  Created by Synergy on 16.08.21.
//

import UIKit
import CoreData

class LandmarkViewController: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var city: City?
    var items = [Landmark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = city?.name ?? "/"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        
               fetchLandmarks()
        
    }
    
    
    func fetchLandmarks(){
        
        do {
            let request = Landmark.fetchRequest() as NSFetchRequest<Landmark>
            
            let pred = NSPredicate(format: "town CONTAINS %@", city?.name as! CVarArg)
            request.predicate = pred
            request.returnsObjectsAsFaults = false
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            
        }
    }
    
    @IBAction func addLandmark(_ sender: UIBarButtonItem) {
        
        
        // create allert
        
        let alert = UIAlertController(title: "Add landmark", message: "What is the landmark?", preferredStyle: .alert)
        alert.addTextField()
        
        // configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            
            let textfield = alert.textFields![0]
            
            let newLandmark = Landmark(context: self.context)
            newLandmark.name = textfield.text
            newLandmark.town = self.city?.name
            newLandmark.city = self.city
            
            let city = City(context: self.context)
            city.addToSights(newLandmark)
            
           
            
            // save data
            do {
                try self.context.save()
            }
            catch {
                print("coudnt fetch")
            }
            // refetch data
            self.fetchLandmarks()
            
        }
        // add button
        alert.addAction(submitButton)
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // swap DELETE
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // create swap action
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action,view,completionHandler)
            in
            // which city to remove
            let landmarkToRemove = self.items[indexPath.row]
            
            let city = City(context: self.context)
            city.removeFromSights(landmarkToRemove)
            
            // remove the city
            self.context.delete(landmarkToRemove)
            // save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            // refetch
            
            self.fetchLandmarks()
        }
        // return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension LandmarkViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "landmarkcell", for: indexPath)
        let landmark = items[indexPath.row]
        
        cell.textLabel?.text = landmark.name ?? "/"
        
        return cell
    }
}

extension LandmarkViewController: UITableViewDataSource {
    
}
