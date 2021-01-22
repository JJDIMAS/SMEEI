//
//  RegisterViewController.swift
//  SMEEI
//
//  Created by Mac19 on 04/01/21.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.layer.cornerRadius = 20.0
        
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
    }
    
}
