//
//  UserData.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

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
}

struct UserFormated{
    var name: String
    var cpf: String
    var balance: String
    var token: String
}

struct StatementData {
    var date: String
    var description: String
    var value: Double
}

