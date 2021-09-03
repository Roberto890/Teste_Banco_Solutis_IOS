//
//  CardCellViewController.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

import Foundation
import UIKit

class CardCellViewController: UITableViewCell{
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    func addCard(statement: StatementData){
        
        lblDescription.text = statement.description
        lblDate.text = statement.date
        lblValue.text = "\(statement.value)"
        
    }
    
}
