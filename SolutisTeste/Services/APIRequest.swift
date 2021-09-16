//
//  APIRequest.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 01/09/21.
//

import Foundation

enum APIErros: String, Error {
    case invalidData = "Credenciais inválidas"
    case invalidAPICall = "Houve erro ao tentar fazer o uso da api"
    case parseError = "Erro ao tentar fazer o parse (JSONDECODER)"
}

struct APIRequest {

    func doLogin(_ loginUser: String, _ passwordUser: String, completionHandler: @escaping (Result<UserData, Error>) -> Void) {
        do {
            let resourceString = "https://api.mobile.test.solutis.xyz/login"
            guard let resourceURL = URL(string: resourceString) else { fatalError()}
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let login = ["username": loginUser, "password": passwordUser] as Dictionary <String, String>
            
            guard let jsonData = try? JSONEncoder().encode(login) else {return}
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if (error != nil){
                    completionHandler(.failure(APIErros.invalidAPICall))
                    return
                }
                
                if (response != nil){
                    let apiResponse = response as! HTTPURLResponse
                    if apiResponse.statusCode > 400 {
                        completionHandler(.failure(APIErros.invalidData))
                    }else if apiResponse.statusCode != 200 {
                        print("api status response: \(apiResponse.statusCode)")
                    }
                }
                
                do{
                    if let user = data {
                        let jsonResponse = try JSONDecoder().decode(UserAPI.self, from: user)
                        let userData = UserData(name: jsonResponse.nome, cpf: jsonResponse.cpf, balance: jsonResponse.saldo, token: jsonResponse.token)
                        completionHandler(.success(userData))
                    }
                } catch {
                    completionHandler(.failure(APIErros.parseError))
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
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(token, forHTTPHeaderField: "token")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {(
                data, response, error) in guard data != nil else {return}
                
                if(error != nil){
                    print(error!)
//                    delegate?.didRequestFailed(self, error: error!)
                }
                
                guard let response = response as? HTTPURLResponse else{
                    return
                }
                
                if response.statusCode == 200{
                    do{
                        let jsonResponse = try JSONDecoder().decode([StatementAPI].self, from: data!)
                        
//                        delegate?.didRequestSuccess(self, data: jsonResponse)
                        
                    }catch{
                        print(error)
//                        delegate?.didRequestFailed(self, error: error)
                    }
                }else{
//                    delegate?.didResponseFailed(self, response: response)
                }
            }
            dataTask.resume()
        }
    }
}

