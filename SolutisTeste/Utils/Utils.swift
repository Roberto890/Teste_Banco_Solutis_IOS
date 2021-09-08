//
//  Utils.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 03/09/21.
//

import Foundation
import JMMaskTextField_Swift
import CPF_CNPJ_Validator
import UIKit

    // MARK:- Validations and cell formatter
class Utils{
    
    func isValidCpfCnpj(_ cpfCnpj: String) -> Bool{
        let cpf = BooleanValidator().validate(cpfCnpj, kind: .CPF)
        let cnpj = BooleanValidator().validate(cpfCnpj, kind: .CNPJ)
        return cpf || cnpj
    }
    
    func isValidEmail(email: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool{
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
        
        cell.cellView.layer.shadowColor = UIColor.black.cgColor
        cell.cellView.layer.shadowPath = UIBezierPath(rect: cell.cellView.bounds).cgPath
        cell.cellView.layer.shadowRadius = 5
        cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.cellView.layer.shadowOpacity = 0.5
        
        cell.lblDate.text = dateFormatter(date: statement.date)
        cell.lblDescription.text = statement.description
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
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
    
    func moneyFormatter(value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(for: value)!
    }
    
    func dateFormatter(date: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        if let formatedDate = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: formatedDate)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }

    func cpfCnpjMask(cpfCnpj: String) -> String{
        let mask: JMStringMask
        if (cpfCnpj.count > 11) {
            mask = JMStringMask(mask: "00.000.000/0000-00")
        }else {
            mask = JMStringMask(mask: "000.000.000-00")
        }
        return mask.mask(string: cpfCnpj)!
    }
    
}

