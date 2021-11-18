//
//  APIRequest.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 01/09/21.
//

import Foundation

protocol APIRequestProtocol {
    func doLogin(_ loginUser: String, _ passwordUser: String, completionHandler: @escaping (Result<UserData, Error>) -> Void)
    func loadStatement(_ token: String, completionHandler: @escaping(Result<[StatementData], Error>) -> Void)
}

enum APIErros: String, Error {
    case invalidData = "Credenciais inválidas"
    case invalidAPICall = "Houve erro ao tentar fazer o uso da api"
    case parseError = "Erro ao tentar fazer o parse (JSONDECODER)"
}

struct APIRequest: APIRequestProtocol {

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
    
    func loadStatement(_ token: String, completionHandler: @escaping(Result<[StatementData], Error>) -> Void) {
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
                    completionHandler(.failure(APIErros.invalidAPICall))
                }
                
                if (response != nil){
                    let apiResponse = response as! HTTPURLResponse
                    if apiResponse.statusCode != 200 {
                        print("api status response: \(apiResponse.statusCode)")
                    }
                }
                
                do{
                    if let statement = data {
                        let jsonResponse = try JSONDecoder().decode([StatementAPI].self, from: statement)
                        var statementsData: [StatementData] = []
                        
                        for value in jsonResponse {
                            let statement = StatementData(date: value.data, description: value.descricao, value: value.valor)
                            statementsData.append(statement)
                        }
                        
                        completionHandler(.success(statementsData))
                    }
                } catch {
                    completionHandler(.failure(APIErros.parseError))
                }
            }
            dataTask.resume()
        }
    }
}

