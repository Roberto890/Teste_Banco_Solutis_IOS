//
//  LoginRouter.swift
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

@objc protocol LoginRoutingLogic {
    func routeToStatement(segue: UIStoryboardSegue?)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {
    weak var viewController: LoginViewController?
    var dataStore: LoginDataStore?
    
    // MARK: Routing
    
    func routeToStatement(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! StatementViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStatement(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "StatementViewController") as! StatementViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToStatement(source: dataStore!, destination: &destinationDS)
            navigateToStatement(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToStatement(source: LoginViewController, destination: StatementViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToStatement(source: LoginDataStore, destination: inout StatementDataStore) {
        destination.userData = source.userData
//        destination.name = source.name
    }
}
