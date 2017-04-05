//
//  ProdutoViewController.swift
//  RaphaelGuilherme
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit
protocol ProdutoCriadoDelegate{
    func produtoCriado(_: Produto)
}

class ProdutoViewController: UIViewController {
    
    var delegate:ProdutoCriadoDelegate?
    
    
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfPreco: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tfEstados: UITextField!
    @IBOutlet weak var swCartao: UISwitch!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addProduto(_ sender: UIButton) {
        var produto = Produto(nome: tfNome.text!, preco: Double(tfPreco.text!)!)
        self.navigationController?.popViewController(animated: true)
        delegate?.produtoCriado(produto)
        
        
    }
    @IBAction func addEstado(_ sender: UIButton) {
        
    }
    
}
