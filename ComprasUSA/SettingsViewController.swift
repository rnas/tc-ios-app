//
//  SettingsViewController.swift
//  RaphaelGuilherme
//
//  Created by rnas on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

enum SettingsType : String {
    case iof    = "val_iof"
    case dolar  = "val_dolar"
}

class SettingsViewController: UIViewController {
    
    var fetchedResultController: NSFetchedResultsController<State>!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var txDolar: UITextField!
    @IBOutlet var txIOF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO reverse process
        
        if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue) {
            txIOF.text = iof
        }
        
        if let dolar = UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue) {
            txDolar.text = dolar
        }
        
    }
    
    
    
    @IBAction func addState(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Adicionar Estado", message: "Preencha os campos abaixo", preferredStyle: .alert)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Nome do Estado"
            UITextField.keyboardType = .default
        }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Taxas do Estado"
            UITextField.keyboardType = .numbersAndPunctuation
        }

        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { (UIAlertAction) in

            // TODO validate
            
            let state = State(context: self.context)
            state.name = alert.textFields?[0].text
            state.tax  = Double((alert.textFields?[1].text)!)!
            
            do {
                try self.context.save()
                self.loadData()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
    
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func loadData() {
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "tax", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell  : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state : State = fetchedResultController.object(at: indexPath)
        
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.detailTextLabel?.tintColor = .red
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "Delete", handler: { (action : UITableViewRowAction, indexPath : IndexPath) in
            
            let state = self.fetchedResultController.object(at: indexPath)
            self.context.delete(state)
            
            do {
                try self.context.save()
            } catch {
                print("Unable to delete Item")
            }
            
            tableView.reloadData()
        })]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count : Int = fetchedResultController.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
        
    }
    
}


extension SettingsViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

