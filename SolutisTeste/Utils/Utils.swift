//
//  Utils.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 03/09/21.
//

import Foundation
import JMMaskTextField_Swift
import CPF_CNPJ_Validators
import UIKit

protocol UtilsProtocol {
    func isValidCpfCnpj(_ cpfCnpj: String) -> Bool
    func isValidEmail(email: String) -> Bool
    func isValidPassword(password: String) -> Bool
    func setGradientBackground(_ view: UIView)
    func formatCellValues(statement: StatementData, cell: CardCellViewController) -> CardCellViewController
    func moneyFormatter(value: Double) -> String
    func dateFormatter(date: String) -> String
    func cpfCnpjMask(cpfCnpj: String) -> String
    func showAlert(_ message: String, ui: UIViewController)
}

    // MARK:- Validations and cell formatter
class Utils: UtilsProtocol {
    
    func isValidCpfCnpj(_ cpfCnpj: String) -> Bool {
        let cpf = CpfCnpjUtils().cpfValidator(cpf: cpfCnpj)
        let cnpj = CpfCnpjUtils().cnpjValidator(cnpj: cpfCnpj)
        return cpf || cnpj
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        if password != "" {
            let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: password)
        }
        return false
    }
    
    func setGradientBackground(_ view: UIView) {
        let colorStart =  UIColor(red: 174.0/255.0, green: 197.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorEnd = UIColor(red: 18.0/255.0, green: 123.0/255.0, blue: 182.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorStart, colorEnd]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
                
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func formatCellValues(statement: StatementData, cell: CardCellViewController) -> CardCellViewController {
        
        cell.lblDate.text = dateFormatter(date: statement.date)
        cell.lblDescription.text = statement.description
        cell.layer.cornerRadius = 10
        
        if statement.value < 0 {
            cell.lblType.text = "Pagamento"
            cell.lblValue.text = moneyFormatter(value: statement.value)
            cell.lblValue.textColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1)
            return cell
        }else{
            cell.lblType.text = "Recebimento"
            cell.lblValue.text = moneyFormatter(value: statement.value)
            cell.lblValue.textColor = UIColor(red: 52.0/255.0, green: 199.0/255.0, blue: 89.0/255.0, alpha: 1)
            return cell
        }
    }
    
    
    
}

    // MARK:- Strings, Money, Date Formatter
extension Utils{
    
    func moneyFormatter(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(for: value)!
    }
    
    func dateFormatter(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        if let formatedDate = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: formatedDate)
        } else {
            debugPrint("There was an error decoding the string")
            return ""
        }
    }

    func cpfCnpjMask(cpfCnpj: String) -> String {
        var result: String = ""
        if (cpfCnpj.count > 11) {
            result = CpfCnpjUtils().cnpjMask(cnpj: cpfCnpj)
        } else {
            result = CpfCnpjUtils().cpfMask(cpf: cpfCnpj)
        }
        return result
    }
    
}

// MARK:- ALERTS CREATOR

extension Utils {
    func showAlert(_ message: String, ui: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            ui.present(alert, animated: true, completion: nil)
        }
    }
}

