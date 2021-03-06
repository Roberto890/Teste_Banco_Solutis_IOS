//
//  LoginInteractor.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 16/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

    //MARK:- Interactor Protocol - called in viewController
protocol LoginInteractorProtocol {
    func doLogin(request: Login.doLogin.Request)
    func keyChainVerification(request: Login.loginView.Request)
    func swtVerifications(request: Login.swtVerification.Request)
    func biometricVerification(request: Login.biometricVerification.Request)
}

    //MARK:- Save data to pass in router
protocol LoginDataStoreProtocol {
    var userData: UserData? {get}
}

class LoginInteractor: LoginInteractorProtocol, LoginDataStoreProtocol {
    
    //MARK:- Interactor variables worker, presenter
    let presenter: LoginPresenterProtocol
    let worker: LoginWorkerProtocol
    
    //MARK:- DataPassing
    var userData: UserData?
    
    init(worker: LoginWorkerProtocol, presenter: LoginPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
    
    //MARK:- Interactor functions (call worker/pass to presenter)
    func doLogin(request: Login.doLogin.Request) {
        worker.doLogin(request.user, request.switchLogin, request.switchBiometric){ result in
            switch result {
            case.success(let userResult):
                self.userData = userResult
                self.presenter.presentUserData(.init(user: self.userData!))
                return
            case.failure(let error):
                self.presenter.presentLoginError(.init(error.localizedDescription))
                return
            }
        }
    }
    
    func keyChainVerification(request: Login.loginView.Request) {
//        worker = LoginWorker()
        worker.keyChainVerification(){ result in
            switch result{
                case.success(let user):
                self.presenter.presentKeyChainData(.init(user: user))
                    return
                case.failure(_):
                    return
            }
        }
    }
    
    func swtVerifications(request: Login.swtVerification.Request) {
//        worker = LoginWorker()
        worker.swtVerifications(type: request.type, swtEmail: request.switchLogin, swtBiometric: request.switchBiometric){result in
            switch result{
                case.success(let result):
                self.presenter.presentSwtVerification(.init(message: result))
                case .failure(let error):
                self.presenter.presentSwtVerification(.init(message: error.localizedDescription))
            }
        }
    }
    
    func biometricVerification(request: Login.biometricVerification.Request) {
//        worker = LoginWorker()
        worker.biometricVerification(context: request.context){result in
            switch result{
                case.success(let userLogin):
                self.presenter.presentBiometricVerification(.init(login: userLogin.login, password: userLogin.password))
                case.failure(let error):
                self.presenter.presentBiometricError(.init(error.localizedDescription))
                    
            }
        }
    }
}
