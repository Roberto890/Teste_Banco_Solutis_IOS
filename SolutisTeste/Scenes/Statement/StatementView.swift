//
//  StatementView.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 29/10/21.
//

import Foundation
import UIKit
import SVProgressHUD

//MARK:- StatementViewProtocol
protocol StatementViewProtocol: AnyObject {
    func displayDoLogout(controller: UIViewController)
    func displayUserData(loadUser: Statement.loadUser.ViewModel)
    func displayLoadStatement(statementData: Statement.loadStatement.ViewModel)
    func displayLoadStatementError(error: String)
    
    func loadGradient()
}

class StatementView: UIView {
    
    //MARK: Variable to viewcontroller
    weak var viewController: StatementViewControllerProtocol?
    
    // MARK: IBOutlets and Variables
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCpfCnpj: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var statementTable: UITableView!
    @IBOutlet weak var viewBackground: UIView!
    
    var statementRequest: [StatementData] = []
        
    // MARK: IBActions
    @IBAction func btnLogout(_ sender: Any) {
        viewController?.callDisplayLogout()
    }
    
    func loadGradient() {
        Utils().setGradientBackground(self.viewBackground)
    }
    
    func showAlertLogout(controller: UIViewController){
        let alert = UIAlertController(title: "Logout", message: "Realmente deseja deslogar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive, handler: { [self]_ in
            viewController?.doLogout()
            
        }))
        
        controller.present(alert, animated: true, completion: nil)
        
    }
    
}

    // MARK: - DISPLAY LOGIC
extension StatementView: StatementViewProtocol {
    
    func displayDoLogout(controller: UIViewController) {
        showAlertLogout(controller: controller)
    }
    
    func displayUserData(loadUser: Statement.loadUser.ViewModel) {
        lblName.text = loadUser.user.formatName
        lblCpfCnpj.text = loadUser.user.formatCpf
        lblBalance.text = loadUser.user.formatBalance
    }
    
    func displayLoadStatement(statementData: Statement.loadStatement.ViewModel) {
        SVProgressHUD.dismiss()
        statementRequest = statementData.statement
        statementTable.reloadData()
    }
    
    func displayLoadStatementError(error: String) {
        SVProgressHUD.dismiss()
        Utils().showAlert(error, ui: viewController as! UIViewController)
        
    }
}

    //MARK:- Table view populating
extension StatementView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = statementTable.dequeueReusableCell(withIdentifier: "statementCell", for: indexPath) as! CardCellViewController
        
        cell = Utils().formatCellValues(statement: statementRequest[indexPath.row], cell: cell)
        
        return cell
    }
}
