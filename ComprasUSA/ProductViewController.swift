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
    
    let pickerView = UIPickerView()
    
    var pickOption = ["c1", "c2", "c3", "c4"]
    
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
        txState.text = pickOption[pickerView.selectedRow(inComponent: 0)]
        print("OWOWOW")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ProductViewController : UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txState.text = pickOption[row]
        txState.resignFirstResponder()
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
