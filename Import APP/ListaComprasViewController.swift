//
//  ListaComprasViewController.swift
//  RaphaelGuilherme
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Fiap. All rights reserved.
//

import UIKit

class ListaComprasViewController: UIViewController {

    
    
    @IBOutlet weak var tvLista: UITableView!
    var dataSource:[Produto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvLista.dataSource = self
        tvLista.delegate = self
        
        dataSource.append(Produto(nome: "Teste1",preco: 10))
        dataSource.append(Produto(nome: "Teste1",preco: 9))
        dataSource.append(Produto(nome: "Teste1",preco: 8))
        dataSource.append(Produto(nome: "Teste1",preco: 7))
        tvLista.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "criar" {
            let destination = segue.destination as! ProdutoViewController
            
            destination.delegate = self
            
        }
    }
    

}

extension ListaComprasViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = dataSource[indexPath.row].nome
        cell?.detailTextLabel?.text = "\(dataSource[indexPath.row].preco)"
            return cell!
    }
}

extension ListaComprasViewController : ProdutoCriadoDelegate{
    func produtoCriado(_ produto: Produto) {
        dataSource.append(produto)
        tvLista.reloadData()
    }
}
