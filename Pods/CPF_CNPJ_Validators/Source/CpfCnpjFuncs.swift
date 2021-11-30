//
//  CpfCnpjFuncs.swift
//  CPF-CNPJ-Utils
//
//  Created by Virtual Machine on 26/11/21.
//

import Foundation

public enum Erros: String, Error {
    case InvalidCpf = "Invalid cpf try again"
    case InvalidCnpj = "Invalid cnpj try again"
}

protocol CpfCnpjProtocol {
    func cpfValidator(cpf: String) -> Bool
    func cpfMask(cpf: String) -> String
    func cnpjValidator(cnpj: String) -> Bool
    func cnpjMask(cnpj: String) -> String
}

extension CpfCnpjProtocol {
    func cpfValidator(cpf: String) -> Bool {
        return cpfValidator(cpf: cpf)
    }
    func cpfMask(cpf: String) -> String {
        return cpfMask(cpf: cpf)
    }
    func cnpjValidator(cnpj: String) -> Bool {
        cnpjValidator(cnpj: cnpj)
    }
    func cnpjMask(cnpj: String) -> String {
        cnpjMask(cnpj: cnpj)
    }
}

public class CpfCnpjUtils: CpfCnpjProtocol {
    
    public init() {}
    
    fileprivate let cpfCnpjFuncs = CpfCnpjFuncs()
    
    public func cpfValidator(cpf: String) -> Bool {
        return cpfCnpjFuncs.cpfValidator(cpf: cpf)
    }
    
    public func cpfMask(cpf: String) -> String {
        return cpfCnpjFuncs.cpfMask(cpf: cpf)
    }
    
    public func cnpjValidator(cnpj: String) -> Bool {
        return cpfCnpjFuncs.cnpjValidator(cnpj: cnpj)
    }
    
    public func cnpjMask(cnpj: String) -> String {
        return cpfCnpjFuncs.cnpjMask(cnpj: cnpj)
    }
    
}

fileprivate class CpfCnpjFuncs: CpfCnpjProtocol {
    
    public init() { }
    
    func cpfValidator(cpf: String) -> Bool {
        let invalidsCpfs = ["11111111111","22222222222","33333333333","44444444444","55555555555","66666666666","77777777777","88888888888","99999999999"]
        
        let newCpf = cpf.replacingOccurrences(of: "[. \\- / \\\\]", with: "", options: .regularExpression, range: nil)
        
        if newCpf.count == 11 {
            if !invalidsCpfs.contains(newCpf) {

                return digitVerificationCpf(cpf: newCpf)
                
            } else {
                return false
            }
        } else {
            return false
        }
        
    }
    
    func cpfMask(cpf: String) -> String {
        
        let rawCpf = cpf.replacingOccurrences(of: "[. \\- / \\\\]", with: "", options: .regularExpression, range: nil)
        
        if rawCpf.count == 11 {
            var index = 0
            var newCpf = ""
            let cpfMask = "###.###.###-##"
            for value in cpfMask {
                if value == "#" {
                    newCpf += rawCpf[index]
                    index += 1
                } else if value == "." {
                    newCpf += "."
                } else {
                    newCpf += "-"
                }
            }
            
            return newCpf
            
        } else {
            return Erros.InvalidCpf.rawValue
        }

    }
    
    func cnpjValidator(cnpj: String) -> Bool {
        
        let invalidsCnpjs = ["11111111111111","22222222222222","33333333333333","44444444444444","55555555555555","66666666666666","77777777777777","88888888888888","99999999999999"]
        
        let rawCnpj = cnpj.replacingOccurrences(of: "[. \\- / \\\\]", with: "", options: .regularExpression, range: nil)
        
        if rawCnpj.count == 14 {
            if !invalidsCnpjs.contains(rawCnpj) {
                return digitVerificationCnpj(cnpj: rawCnpj)
            } else {
                return false
            }
            
        } else {
            return false
            
        }
    }
    
    func cnpjMask(cnpj: String) -> String {
        
        let rawCnpj = cnpj.replacingOccurrences(of: "[. \\- / \\\\]", with: "", options: .regularExpression, range: nil)
        
        if cnpjValidator(cnpj: rawCnpj) {
            if rawCnpj.count == 14 {
                var index = 0
                var newCnpj = ""
                let cnpjMask = "##.###.###/####-##"
                for value in cnpjMask {
                    if value == "#" {
                        newCnpj += rawCnpj[index]
                        index += 1
                    } else if value == "." {
                        newCnpj += "."
                    } else if value == "/" {
                        newCnpj += "/"
                    } else {
                        newCnpj += "-"
                    }
                }
                
                return newCnpj
                
            } else {
                return Erros.InvalidCnpj.rawValue
            }
        } else {
            return Erros.InvalidCnpj.rawValue
        }
    }
    
    
    private func digitVerificationCpf(cpf: String) -> Bool {
        var firstDigitVerification = 0
        var secondDigitVerification = 0
        var multiNumber = 10
        
        for index in 0...8 {
            guard let intValue = Int(cpf[index]) else { return false }
            firstDigitVerification += intValue * multiNumber
            multiNumber -= 1
        }
        
        multiNumber = 11
        
        for index in 0...9 {
            guard let intValue = Int(cpf[index]) else { return false }
            secondDigitVerification += intValue * multiNumber
            multiNumber -= 1
        }
        
        firstDigitVerification = (11 - (firstDigitVerification % 11)) >= 10 ? 0 : (11 - (firstDigitVerification % 11))
        secondDigitVerification = (11 - (secondDigitVerification % 11)) >= 10 ? 0 : (11 - (secondDigitVerification % 11))
        if firstDigitVerification == Int(cpf[9]) && secondDigitVerification == Int(cpf[10]) {
            return true
        } else {
            return false
        }
    }
    
    func digitVerificationCnpj(cnpj: String) -> Bool {
        var firstDigitVerification = 0
        var secondDigitVerification = 0
        var multiNumber = 2
        
        for index in (0...11).reversed() {
            guard let intValue = Int(cnpj[index]) else { return false }
            firstDigitVerification += intValue * multiNumber
            if multiNumber == 9 {
                multiNumber = 2
            } else {
                multiNumber += 1
            }
        }
        
        multiNumber = 2
        
        for index in (0...12).reversed()  {
            guard let intValue = Int(cnpj[index]) else { return false }
            secondDigitVerification += intValue * multiNumber
            
            if multiNumber == 9 {
                multiNumber = 2
            } else {
                multiNumber += 1
            }
        }
        
        firstDigitVerification = (11 - (firstDigitVerification % 11)) >= 10 ? 0 : (11 - (firstDigitVerification % 11))
        secondDigitVerification = (11 - (secondDigitVerification % 11)) >= 10 ? 0 : (11 - (secondDigitVerification % 11))
        if firstDigitVerification == Int(cnpj[12]) && secondDigitVerification == Int(cnpj[13]) {
            return true
        } else {
            return false
        }
    }
    
}



extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


