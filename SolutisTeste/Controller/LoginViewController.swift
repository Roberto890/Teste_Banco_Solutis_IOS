//
//  LoginViewController.swift
//  TesteSolutisRoberto
//
//  Created by Administrator on 8/19/21.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, APIResquestDelegate, UITextFieldDelegate {
    
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

        if (Utils().isValidEmail(email: login) == true && Utils().isValidPassword(password: password) == true){
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
    
    //MARK:- TEXT FIELD Verification
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtError.isHidden = true
        return true
    }
    
    

    // MARK:- API RESPONSE
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.async {
            let userData = data as! UserAPI
            self.dataUser.populate(userData)
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        DispatchQueue.main.async {
            print(error)
            SVProgressHUD.dismiss()
        }
    }
    
    func didResponseFailed(_: APIRequest, response: HTTPURLResponse) {
        DispatchQueue.main.async {
            print(response)
            self.txtError.isHidden = false
            SVProgressHUD.dismiss()
        }
    }
    
}

