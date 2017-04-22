//
//  TotalViewController.swift
//  RaphaelGuilherme
//
//  Created by rnas on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet var lbUS: UILabel!
    @IBOutlet var lbRS: UILabel!
    
    var iof     : Double = 0
    var dolar  : Double = 0
    
    var dataSource : [Product] = []
//    var fetchedResultController: NSFetchedResultsController<Product>!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let iof_ = Double(UserDefaults.standard.string(forKey: SettingsType.iof.rawValue)!) {
            self.iof = iof_
        }
        
        if let dolar_ = Double(UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue)!) {
            self.dolar = dolar_
        }
        
        loadSumData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadSumData() {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            try dataSource = context.fetch(fetchRequest)
            self.calculateTaxes()
        } catch {
            print("error")
        }
        
    }
    
    func calculateTaxes() {
   
        let totalDolars = dataSource.reduce(0) { (sum, product) -> Double in
            let iof = product.usedCard ? product.price * (self.iof / 100) : 0
            return sum + iof + product.price + (product.price * (((product.state?.tax)! / 100)))
        }
        
        let fmt : NumberFormatter = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "BRL"
        
        let BRL = NSNumber(value: totalDolars * self.dolar)
        lbRS.text = fmt.string(from: BRL)
        
        let USD = NSNumber(value: totalDolars)
        
        fmt.currencyCode = "USD"
        lbUS.text = fmt.string(from: USD)
        
    }
}


//
//extension TotalViewController : NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        
//        print("loaded data")
//        
//        let sum = fetchedResultController.fetchedObjects?.reduce(0, { (value, element) -> Double in
//            
//            return value + element.price + element.price * (element.state?.tax)!
//            
//        })
//        
//        print(sum ?? "errow")
//        
//    }
//}
