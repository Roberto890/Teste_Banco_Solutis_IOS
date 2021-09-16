//
//  LoginViewController.swift
//  TesteSolutisRoberto
//
//  Created by Administrator on 8/19/21.
//

import UIKit
import SVProgressHUD
import KeychainAccess
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var swtBiometric: UISwitch!
    @IBOutlet weak var swtEmail: UISwitch!
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
        keyChainLoad()
    }

    // MARK:- IBActions
    
    @IBAction func btnLogin(_ sender: Any) {
        self.btnLogin.isEnabled = false
        guard let login = txtUsername.text else{return}
        guard let password = txtPassword.text else{return}
        keyChainDelete()
        doLogin(login, password)
    }
    
    @IBAction func swtEmailChanged(_ sender: Any) {
        swtVerifications(type: "Email")
    }
    
    @IBAction func dismissKeyboardTop(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissKeyboardMiddle(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swtBiometricChanged(_ sender: Any) {
        swtVerifications(type: "Biometric")
    }
}

    // MARK:- Login Functions and Segue
extension LoginViewController {
    func doLogin(_ login: String,_ password: String){
        if ((Utils().isValidEmail(email: login) == true || Utils().isValidCpfCnpj(login) ==  true)) && Utils().isValidPassword(password: password) == true {
            SVProgressHUD.show()
            apiRequest?.login(login, password)
        }else{
            txtError.isHidden = false
            self.btnLogin.isEnabled = true
        }
    }
    
    func swtVerifications(type: String){
        if(swtEmail.isOn == false && swtBiometric.isOn == true) {
            var message = ""
            if (type == "Email") {
                message = "Caso não queria salvar o email desabilite a opção Habilitar Biometria antes do Salvar email"
            }else{
                message = "A biometria estará ativa na proxima tentativa de login"
            }
            
            let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            swtEmail.isOn = true
            
        }else if(swtBiometric.isOn == true){
            let alert = UIAlertController(title: "Aviso", message: "A biometria estará ativa na proxima tentativa de login", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue") {
            let vc = segue.destination as? StatementViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.userLogedData = dataUser
        }
    }
}

// MARK:- Biometric And FaceID
extension LoginViewController {
    func biometricVerification(){
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Porfavor autorize com a biometria!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] sucess, error in
                DispatchQueue.main.async {
                    
                    guard sucess, error == nil else{
                        let alert = UIAlertController(title: "Falha ao autenticar", message: "Porfavor tente novamente.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    self?.doLogin(self!.txtUsername.text!, self!.txtPassword.text!)
                }
            }
        } else {
            let alert = UIAlertController(title: "FaceID ou Biometria", message: "Desculpe está feature esta indisponível para este aparelho, Porfavor habilite nas configurações", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            swtBiometric.isOn = false
            
            
        }
    }
}

    //MARK:- TEXT FIELD Implementations
extension LoginViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtError.isHidden = true
        return true
    }
}

    // MARK:- Api Response
extension LoginViewController: APIResquestDelegate{
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.async {
            let userData = data as! UserAPI
            self.dataUser.populate(userData)
            SVProgressHUD.dismiss()
            self.btnLogin.isEnabled = true
            self.keyChainSave()
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        DispatchQueue.main.async {
            print(error)
            SVProgressHUD.dismiss()
            self.btnLogin.isEnabled = true
        }
    }
    
    func didResponseFailed(_: APIRequest, response: HTTPURLResponse) {
        DispatchQueue.main.async {
            if (response.statusCode == 401) {
                let alert = UIAlertController(title: "Aviso", message: "Credenciais inválidas", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                self.txtError.isHidden = false
            }
            SVProgressHUD.dismiss()
            self.btnLogin.isEnabled = true
        }
    }
}

    // MARK:- KeyChain Functions

extension LoginViewController {
    func keyChainSave(){
        let keychain = Keychain(service: "com.roberto.SolutisTeste")
        if (swtBiometric.isOn == true){
            keychain["username"] = self.txtUsername.text
            keychain["password"] = self.txtPassword.text
        }else if(swtEmail.isOn == true){
            keychain["username"] = self.txtUsername.text
        }
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
    func keyChainLoad(){
        let keychain = Keychain(service: "com.roberto.SolutisTeste")
        guard let username = keychain["username"] else {return}
        if (username != "") {
            swtEmail.isOn = true
        }
        txtUsername.text = username
        guard let password = keychain["password"] else {return}
        if (password != "") {
            swtBiometric.isOn = true
            biometricVerification()
        }
        txtPassword.text = password
    }
    
    func keyChainDelete(){
        let keychain = Keychain(service: "com.roberto.SolutisTeste")
        if (swtBiometric.isOn == false){
            keychain["password"] = nil
        }
        if(swtEmail.isOn == false){
            keychain["username"] = nil
        }
    }
}
