//
//  ViewController.swift
//  Travel App
//
//  Created by Synergy on 12.08.21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    struct Constants {
        static let landamarkSegueIdentifier = "landamarkSegueIdentifier"
        static let cityCellIdentifier = "cityCellIdentifier"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [City]()
    var selectedCity: City?
    var cityHasLandmarks = [Landmark]()
    var cityToRemove: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities"
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        fetchCities()
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.landamarkSegueIdentifier:
            let landmarkViewController = (segue.destination as! LandmarkViewController)
            landmarkViewController.city = self.selectedCity
            
        default:
            break
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
    func fetchCities(){
        do {
            self.items = try context.fetch(City.fetchRequest())
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        catch {
            
        }
    }
    func fetchLandmarks(){
        
        do {
            let request = Landmark.fetchRequest() as NSFetchRequest<Landmark>
            
            let pred = NSPredicate(format: "town CONTAINS %@", cityToRemove?.name as! CVarArg)
            request.predicate = pred
            
            self.cityHasLandmarks = try context.fetch(request)
            //print(cityHasLandmarks.count)
           
        }
        catch {
            
        }
    }
    
    @IBAction func addTapped (_ sender: UIBarButtonItem) {
        
        
        // create allert
        
        let alert = UIAlertController(title: "Add city", message: "What is the city's name?", preferredStyle: .alert)
        alert.addTextField()
        
    
        // configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            
            
            let textfield = alert.textFields![0]
            
            let newCity = City(context: self.context)
            newCity.name = textfield.text
            
            // save data
            do {
                try self.context.save()
            }
            catch {
                
            }
            // refetch data
            self.fetchCities()
            
            
                    }
        
        
        
        // add button
        alert.addAction(submitButton)
        
        // show alert
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityCellIdentifier, for: indexPath)
        
        let city = self.items[indexPath.row]
        

        cell.textLabel?.text = city.name ?? "nema"
        
        return cell
        
        
        
    }
    
    // Delete city
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // create swap action
        let action = UIContextualAction(style: .destructive, title: "Delete") {(action,view,completionHandler)
            in
            // which city to remove
            self.cityToRemove = self.items[indexPath.row]
           
            
            self.fetchLandmarks()
            if self.cityHasLandmarks.count > 0 {
                print("ne mojehs da triesh")
            }
            else {
                // remove the city
                self.context.delete(self.cityToRemove!)
                // save the data
                do {
                    try self.context.save()
                }
                catch {
                    
                }
            }
            
            
            // refetch
            
            self.fetchCities()
        }
        // return swipe actions
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = self.items[indexPath.row]
        
        self.selectedCity = city
        
        performSegue(withIdentifier: Constants.landamarkSegueIdentifier, sender: self)
       
    }
    
    
}
