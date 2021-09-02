//
//  APIRequest.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 01/09/21.
//

import Foundation

protocol APIResquestDelegate {
    func didRequestSuccess(_: APIRequest, data: Any)
    func didRequestFailed(_: APIRequest, error: Error)
}

struct APIRequest {
    
    var delegate: APIResquestDelegate?
    
    func login(_ loginUser: String, _ passwordUser: String) {
        do {
            let resourceString = "https://api.mobile.test.solutis.xyz/login"
            guard let resourceURL = URL(string: resourceString) else { fatalError()}
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let login = ["username": loginUser, "password": passwordUser] as Dictionary <String, String>
            
            guard let jsonData = try? JSONEncoder().encode(login) else {return}
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {(
                data, response, error) in guard data != nil else {return}
                
                if(error != nil){
                    print(error!)
                    delegate?.didRequestFailed(self, error: error!)
                }
                
                do{
                    
                    let jsonResponse = try JSONDecoder().decode(UserAPI.self, from: data!)
                    
                    delegate?.didRequestSuccess(self, data: jsonResponse)
                    
                }catch{
                    delegate?.didRequestFailed(self, error: error)
                }
                
            }
            dataTask.resume()
        }
    }
    
    func statement(_ token: String) {
        do {
            
            let resourceString = "https://api.mobile.test.solutis.xyz/extrato"
            guard let resourceURL = URL(string: resourceString) else { fatalError()}
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "GET"
            
            urlRequest.addValue(token, forHTTPHeaderField: "Token")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {(
                data, response, error) in guard data != nil else {return}
                
                if (error != nil){
                    print(error!)
                    delegate?.didRequestFailed(self, error: error!)
                }
                
                do{
                    let jsonResponse = try JSONDecoder().decode([StatementAPI].self, from: data!)
                    
                    delegate?.didRequestSuccess(self, data: jsonResponse)
                    
                }catch{
                    print(error)
                    delegate?.didRequestFailed(self, error: error)
                }
            }
            dataTask.resume()
        }
    }
}

