//
//  DescriptionViewController.swift
//  Travel App
//
//  Created by Synergy on 20.08.21.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var textView: UITextView!
    
    var landmark: Landmark?
    var fetch: (() -> Any)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = landmark?.name
        textView.text = landmark?.descript ?? "Still no text to show"
        textView.setNeedsDisplay()
        //print(landmark as Any)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addDescription(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add description", message: "Say somehting cool about this landmark ", preferredStyle: .alert)
        alert.addTextField()
        
        // configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { [self] action in
            
            let textfield = alert.textFields![0]
            
            
            self.landmark?.descript = textfield.text
            textView.text = textfield.text
            //print(self.landmark?.descript)
            
            // save data
            do {
                try self.context.save()
            }
            catch {
                print("coudnt fetch")
            }
            // refetch data
            //self.fetch!()
            
            
        }
        // add button
        alert.addAction(submitButton)
        // show alert
        self.present(alert, animated: true, completion: nil)
    }
    

     @IBAction func closeModal(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
     }
    /*
    // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
