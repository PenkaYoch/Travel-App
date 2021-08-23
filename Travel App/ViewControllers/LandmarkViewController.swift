//
//  LandmarkViewController.swift
//  Travel App
//
//  Created by Synergy on 16.08.21.
//

import UIKit
import CoreData

class LandmarkViewController: UIViewController {
    
    struct Constants {
        static let descriptionSegueIdentifier = "descriptionSegueIdentifier"
        static let landmarkcellIdentifier = "landmarkcell"
    }
    
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var city: City?
    var items = [Landmark]()

    var selectedLandmark: Landmark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = city?.name ?? "/"
        
        print(self.city?.sights?.allObjects)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        textView.backgroundColor = .green
        textView.text = city?.descript ?? "no text to show"
        
        fetchLandmarks()
        
    }
    
    
    func fetchLandmarks(){
        
        do {
            let request = Landmark.fetchRequest() as NSFetchRequest<Landmark>
            
            guard let cityName = city?.name else {
                return
            }
            
            let pred = NSPredicate(format: "town CONTAINS %@", cityName)
            request.predicate = pred
            request.returnsObjectsAsFaults = false
            
            self.items = try context.fetch(request)
            
            textView.text = city?.descript ?? "no text to show"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.descriptionSegueIdentifier:
            let descriptionViewController = (segue.destination as! DescriptionViewController)
            
            let fetchForChildren = {
                self.fetchLandmarks()
            }
            
            descriptionViewController.landmark = self.selectedLandmark
            descriptionViewController.fetch = fetchForChildren
            
            
        default:
            break
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            //print(city.sights)
            
           
            
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
    
    
    @IBAction func addDescription(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Add description", message: "Say somehting cool about the city ", preferredStyle: .alert)
        alert.addTextField()
        
        // configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            
            let textfield = alert.textFields![0]
            
            
            
            self.city?.descript = textfield.text
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let landmark = self.items[indexPath.row]
        
        self.selectedLandmark = landmark
        
        performSegue(withIdentifier: Constants.descriptionSegueIdentifier, sender: self)
        
    }
}

extension LandmarkViewController: UITableViewDataSource {
    
}
