//
//  LoginView.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 29/10/21.
//

import Foundation
import UIKit

protocol LoginViewProtocol: AnyObject {
    func enableButton()
    func displayError()
    func displayKeyChainData(userLogin: Login.loginView.ViewModel)
    func displaySwtError(error: String)
    func displaySwtVerification(message: String)
    func displayBiometricVerification(user: Login.biometricVerification.ViewModel)
    func displayBiometricError(error: String)

}

class LoginView: UIView {
    
    // MARK: - Initializer
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    //MARK: Variable to viewcontroller
    weak var viewController: LoginViewControllerProtocol?
    
    // MARK: IBOutlets and Variables
    @IBOutlet weak var swtBiometric: UISwitch!
    @IBOutlet weak var swtEmail: UISwitch!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    //  UIView functions
    @IBAction func btnLogin(_ sender: Any) {
        self.btnLogin.isEnabled = false
        guard let login = txtUsername.text else{return}
        guard let password = txtPassword.text else{return}
        let userLogin = UserLogin(login: login, password: password)
        viewController?.doLogin(user: userLogin, swtEmail: swtEmail, swtBiometric: swtBiometric)
    }
    
    @IBAction func swtEmailChanged(_ sender: Any) {
        viewController?.switchVerification(type: "Email", swtEmail: swtEmail.isOn, swtBiometric: swtBiometric.isOn)
    }
    
    @IBAction func swtBiometricChanged(_ sender: Any) {
        viewController?.switchVerification(type: "Biometric", swtEmail: swtEmail.isOn, swtBiometric: swtBiometric.isOn)
    }
    
    @IBAction func dismissKeyboardTop(_ sender: Any) {
        self.endEditing(true)
    }
    
    @IBAction func dismissKeyboardMiddle(_ sender: Any) {
        self.endEditing(true)
    }
    
//    func doLogin(user: UserLogin, swtLogin: UISwitch, swtBiometric: UISwitch){
//        let request = Login.doLogin.Request(user: user, switchLogin: swtEmail.isOn, switchBiometric: swtBiometric.isOn)
////        interactor!.doLogin(request: request)
//    }
    
}

    //MARK:- TEXT FIELD Implementations
extension LoginView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        txtError.isHidden = true
        return true
    }
}

    //MARK:- LoginDisplayLogic - Presenter Return
extension LoginView: LoginViewProtocol {
   
    func enableButton() {
        btnLogin.isEnabled = true
    }
    
    func displayError() {
        txtError.isHidden = false
        btnLogin.isEnabled = true
    }
    
    func displayKeyChainData(userLogin: Login.loginView.ViewModel ) {
        txtUsername?.text = userLogin.user.login
        txtPassword?.text = userLogin.user.password
        
        if txtUsername.text != "" {
            swtEmail.isOn = true
        } else {
            swtEmail.isOn = false
        }
        
        if self.txtPassword.text != "" {
            swtBiometric.isOn = true
            viewController?.biometricVerification()
        } else {
            swtBiometric.isOn = false
        }
    }
    
    func displaySwtError(error: String) {
        Utils().showAlert(error, ui: viewController as! UIViewController)
        swtEmail.isOn = true
    }
    
    func displaySwtVerification(message: String) {
        Utils().showAlert(message, ui: viewController as! UIViewController)
        swtEmail.isOn = true
    }
    
    func displayBiometricVerification(user: Login.biometricVerification.ViewModel) {
//        let swtLogin = swtEmail!
//        swtLogin.isOn = true
//        let swtBiometric = swtBiometric!
//        swtBiometric.isOn = true
        swtEmail.isOn = true
        swtBiometric.isOn = true
        viewController?.doLogin(user: user.user, swtEmail: swtEmail, swtBiometric: swtBiometric)
        
    }
    
    func displayBiometricError(error: String) {
        Utils().showAlert(error, ui: viewController as! UIViewController)
        swtBiometric.isOn = false
    }
}
