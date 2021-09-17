//
//  UserData.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

//MARK:- MODELS FOR DATA

import Foundation

struct UserLogin {
    var login: String
    var password: String
}

struct UserData {
    var name: String
    var cpf: String
    var balance: Double
    var token: String
    
    var formatCpf: String {
        return Utils().cpfCnpjMask(cpfCnpj: self.cpf)
    }
    
    var formatBalance: String{
        return Utils().moneyFormatter(value: self.balance)
    }
}

struct StatementData {
    var date: String
    var description: String
    var value: Double
    
    var formatedData: String {
        return Utils().dateFormatter(date: date)
    }
    
    var formatedValue: String {
        return Utils().moneyFormatter(value: value)
    }
    
}

