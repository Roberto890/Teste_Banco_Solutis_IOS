//
//  UserData.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

import Foundation

class UserLogin {
    var login: String!
    var password: String!
}

class UserData {
    var name: String!
    var cpf: String!
    var balance: Double!
    var token: String!
    
    func populate(_ userData: UserAPI) {
        self.name = userData.nome
        self.cpf = userData.cpf
        self.balance = userData.saldo
        self.token = userData.token
    }
    
}

class StatementData {
    var date: String!
    var description: String!
    var value: Double!
    
    func populate(_ statementData: StatementAPI) {
        self.date = statementData.descricao
        self.description = statementData.descricao
        self.value = statementData.valor
    }

}
