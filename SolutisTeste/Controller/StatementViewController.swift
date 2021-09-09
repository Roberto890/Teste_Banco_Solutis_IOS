//
//  StatementViewController.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

import Foundation
import SVProgressHUD
import UIKit

class StatementViewController: UIViewController {

    var apiRequest: APIRequest? = APIRequest()
    var statementRequest: [StatementData] = []
    var userLogedData: UserData?
    var viewsCount: Int = 0
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCpfCnpj: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var statementTable: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        apiRequest?.delegate = self
        SVProgressHUD.show()
        loadStatementData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        Utils().setGradientBackground(viewBackground)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        doLogout()
    }
}

// MARK:- Functions
extension StatementViewController{
    
    func loadUserData() {
        lblName.text = "Olá, \((userLogedData?.name)!)"
        lblCpfCnpj.text = Utils().cpfCnpjMask(cpfCnpj: (userLogedData?.cpf)!)
        lblBalance.text = "\(Utils().moneyFormatter(value: (userLogedData!.balance)))"
    }
    
    func loadStatementData(){
        apiRequest?.statement((userLogedData?.token)!)
    }
    
    func doLogout(){
        let alert = UIAlertController(title: "Logout", message: "Realmente deseja deslogar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive, handler: {_ in
                                        self.navigationController?.popViewController(animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
}

    //MARK:- API RESPONSE
extension StatementViewController: APIResquestDelegate{
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.sync {
            let statementData = data as! [StatementAPI]
            for statement in statementData{
                let statementConverter: StatementData = StatementData()
                statementConverter.populate(statement)
                self.statementRequest.append(statementConverter)
            }
            statementTable.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        DispatchQueue.main.sync {
            print(error)
            SVProgressHUD.dismiss()
        }
    }
    
    func didResponseFailed(_: APIRequest, response: HTTPURLResponse) {
        DispatchQueue.main.sync {
            print(response)
            SVProgressHUD.dismiss()
        }
    }
}

    //MARK:- Table view populating
extension StatementViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = statementTable.dequeueReusableCell(withIdentifier: "statementCell", for: indexPath) as! CardCellViewController

        cell = Utils().formatCellValues(statement: statementRequest[indexPath.row], cell: cell)
        
        return cell
    }
    
}

