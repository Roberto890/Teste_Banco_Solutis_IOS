//
//  StatementViewController.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

import Foundation
import SVProgressHUD
import UIKit

class StatementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIResquestDelegate {
    
    var apiRequest: APIRequest? = APIRequest()
    var statementRequest: [StatementData] = []
    var userLogedData: UserData?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCpfCnpj: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var statementTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        loadStatementData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadUserData() {
        lblName.text = userLogedData?.name
        lblCpfCnpj.text = userLogedData?.cpf
        lblBalance.text = "\(String(describing: userLogedData?.balance))"
    }
    
    func loadStatementData(){
        SVProgressHUD.show()
        apiRequest?.statement((userLogedData?.token)!)
    }
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.sync {
            let statementData = data as! Array<StatementAPI>
            for statement in statementData{
                let statementConverter: StatementData = StatementData()
                statementConverter.populate(statement)
                self.statementRequest.append(statementConverter)
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        print(error)
        SVProgressHUD.dismiss()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statementTable.dequeueReusableCell(withIdentifier: "statementCell", for: indexPath) as! CardCellViewController
        
        cell.lblDate.text = statementRequest[indexPath.row].date
        cell.lblValue.text = "\(String(describing: statementRequest[indexPath.row].value))"
        cell.lblType.text = "teste"
        cell.lblDescription.text = statementRequest[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGFloat(tableView.frame.size.height / 4)
        return size
    }
    
}
