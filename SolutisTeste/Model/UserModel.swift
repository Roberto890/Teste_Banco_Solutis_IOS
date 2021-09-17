//
//  UserData.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 01/09/21.
//

//MARK:- MODELS FOR API

import Foundation

struct UserAPI: Decodable{
    let nome: String
    let cpf: String
    let saldo: Double
    let token: String
}

struct StatementAPI: Decodable {
    let data: String
    let descricao: String
    let valor: Double
}
