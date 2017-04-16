//
//  ProductViewController.swift
//  RaphaelGuilherme
//
//  Created by rnas on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {

    @IBOutlet var txName: UITextField!
    @IBOutlet var ivImage: UIImageView!
    @IBOutlet var btImage: UIButton!
    @IBOutlet var txState: UITextField!
    @IBOutlet var txValue: UITextField!
    @IBOutlet var usingCard: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addProduct(_ sender: Any) {
        
        let product = Product(context: self.context)
        
        product.name = txName.text
        product.state = nil
        product.price = Double(txValue.text!)!
        product.usedCard = usingCard.isOn
        product.image = nil
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
