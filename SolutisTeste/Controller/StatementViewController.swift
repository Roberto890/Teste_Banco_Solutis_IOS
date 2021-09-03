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
        apiRequest?.delegate = self
        SVProgressHUD.show()
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
        apiRequest?.statement((userLogedData?.token)!)
    }

    //MARK:- API RESPONSE
    
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
    
    //MARK:- Table view populating
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statementTable.dequeueReusableCell(withIdentifier: "statementCell", for: indexPath) as! CardCellViewController
        
        if ((statementRequest[indexPath.row].value)!) < 0{
            print("arrumar a cor etc")
        }
        cell.lblDate.text = statementRequest[indexPath.row].date
        cell.lblValue.text = "\((statementRequest[indexPath.row].value)!)"
        cell.lblType.text = "teste"
        cell.lblDescription.text = statementRequest[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGFloat(tableView.frame.size.height / 4)
        return size
    }
    
}
