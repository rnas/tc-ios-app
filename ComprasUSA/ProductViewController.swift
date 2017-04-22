//
//  ProductViewController.swift
//  RaphaelGuilherme
//
//  Created by rnas on 15/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
import CoreData

protocol ProductUpdatedDelegate {
    func productsUpdated()
}

class ProductViewController: UIViewController {

    @IBOutlet var txName: UITextField!
    @IBOutlet var ivImage: UIImageView!
    @IBOutlet var btImage: UIButton!
    @IBOutlet var txState: UITextField!
    @IBOutlet var txValue: UITextField!
    @IBOutlet var usingCard: UISwitch!
    
    let pickerView = UIPickerView()
    
    var delegate : ProductUpdatedDelegate?
    var product : Product?
    var state : State!
    
    var fetchedResultController: NSFetchedResultsController<State>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product == nil {
            return
        } else {
            
            txName.text = product!.name
            txValue.text = "\(product!.price)"
            usingCard.isOn = product!.usedCard
            
            if ((product!.image) != nil) {
                ivImage.image = product!.image as! UIImage
            }
            
            if (product!.state != nil) {
                txState.text = product!.state?.name
                state = product?.state
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCategoriesData()
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
        if product == nil {
            product = Product(context: self.context)
        }
        
        product?.name = txName.text
        product?.price = Double(txValue.text!)!
        product?.usedCard = usingCard.isOn
        product?.image = ivImage.image
        product?.state = state
    
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar Imagem", message: "De onde você deseja escolher a imagem do produto?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action : UIAlertAction) in
            self.selectPicture(sourceType: .camera)
        }
        
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Galeria", style: .default) { (action : UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType : UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func loadCategoriesData() {
        
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
    
    @IBAction func selectState(_ sender: Any) {
    
        let toolbar = UIToolbar()
        
        toolbar.backgroundColor = .white
        toolbar.isTranslucent = false
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Selecionar", style: .done, target: self, action: #selector(ProductViewController.pickerviewSelected))
        ]
        
        pickerView.delegate = self
        
        txState.inputAccessoryView = toolbar
        txState.inputView = pickerView
    }
    
    func pickerviewSelected() {
        txState.resignFirstResponder()
        txState.text = fetchedResultController.fetchedObjects?[pickerView.selectedRow(inComponent: 0)].name
        state = fetchedResultController.fetchedObjects?[pickerView.selectedRow(inComponent: 0)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProductViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //        tableView.reloadData()
    }
}

extension ProductViewController : UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (fetchedResultController.fetchedObjects?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fetchedResultController.fetchedObjects?[row].name
    }
}


extension ProductViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Reduzir imagem
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}


