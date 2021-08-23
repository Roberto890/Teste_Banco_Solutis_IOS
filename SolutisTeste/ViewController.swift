//
//  ViewController.swift
//  TesteSolutisRoberto
//
//  Created by Administrator on 8/19/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var swtBiometric: UISwitch!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 5
        
    }

    @IBAction func action(_ sender: Any) {
        txtError.isHidden = false
    }
    
}

