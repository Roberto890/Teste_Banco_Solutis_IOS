//
//  CardCellViewController.swift
//  SolutisTeste
//
//  Created by Virtual Machine on 02/09/21.
//

import Foundation
import UIKit

class CardCellViewController: UITableViewCell {
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        
        
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowPath = UIBezierPath(rect: cellView.bounds).cgPath
        cellView.layer.shadowRadius = 10
        cellView.layer.shadowOffset = CGSize(width: 0, height: 20)
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.masksToBounds = false
        contentView.layer.masksToBounds = true
        
        cellView.layer.cornerRadius = 10
        
//        contentView.layer.masksToBounds = true
//        cellView.layer.masksToBounds = false
        
    }
    
}
