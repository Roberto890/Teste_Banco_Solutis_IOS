//
//  LoginViewController.swift
//  TesteSolutisRoberto
//
//  Created by Administrator on 8/19/21.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, APIResquestDelegate {
    
    
    @IBOutlet weak var swtBiometric: UISwitch!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    var apiRequest: APIRequest? = APIRequest()
    var dataUser: UserData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest?.delegate = self
        btnLogin.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnLogin(_ sender: Any) {
        
        guard let login = txtUsername.text else{return}
        guard let password = txtPassword.text else{return}
        
        
        doLogin(login, password)
    }
    
    func doLogin(_ login: String,_ password: String){

        if (validations().isValidEmail(email: login) == true && validations().isValidPassword(password: password) == true) {
            SVProgressHUD.show()
            apiRequest?.login(login, password)
        }else{
            txtError.isHidden = false
            SVProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let vc = segue.destination as? StatementViewController
            vc?.userLogedData = dataUser
        }
    }
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.sync {
            let userData = data as! UserAPI
            self.dataUser.populate(userData)
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        print(error)
        SVProgressHUD.dismiss()
    }
    
    class validations{
        func isValidEmail(email: String) -> Bool{
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPred.evaluate(with: email)
        }
        
        func isValidPassword(password: String) -> Bool{
            if password != "" {
                let passwordRegex = "[a-z0-9._%=-@]"
                let passwordPred = NSPredicate(format: "SELF CONTAINS %@", passwordRegex)
                return passwordPred.evaluate(with: passwordRegex)
            }
            return false
        }
    }
}

