//
//  ShoppingsViewController.swift
//  RaphaelGuilherme
//
//  Created by rnas on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class ShoppingsViewController: UIViewController {

    var fetchedResultController: NSFetchedResultsController<Product>!
    let fmt : NumberFormatter = NumberFormatter()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fmt.numberStyle = .currency
        fmt.currencyCode = "USD"
        
        loadData()
    }
}

extension ShoppingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func loadData() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "price", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count : Int = fetchedResultController.fetchedObjects?.count {
            return count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //  
        let vc = storyboard?.instantiateViewController(withIdentifier: "edit") as! ProductViewController
        
        vc.product = self.fetchedResultController.object(at: indexPath)
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction.init(style: .destructive, title: "Delete", handler: { (action : UITableViewRowAction, indexPath : IndexPath) in
            
            let product = self.fetchedResultController.object(at: indexPath)
            self.context.delete(product)
            
            do {
                try self.context.save()
            } catch {
                print("Unable to delete Item")
            }
            
            tableView.reloadData()
        })]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let product : Product = fetchedResultController.object(at: indexPath)
        
        cell.textLabel?.text = product.name
        if let image = product.image as? UIImage {
            cell.imageView?.image = image
            cell.imageView?.clipsToBounds = true
            cell.imageView?.layer.cornerRadius = 22
        }
        
        let USD = NSNumber(value: product.price)
        cell.detailTextLabel?.text = fmt.string(from: USD)
        
        return cell
        
    }
}

extension ShoppingsViewController: ProductUpdatedDelegate {
    func productsUpdated() {
        loadData()
    }
}

extension ShoppingsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}




