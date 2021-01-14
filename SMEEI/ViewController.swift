//
//  ViewController.swift
//  SMEEI
//
//  Created by Mac19 on 30/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accessButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accessButton.layer.cornerRadius = 20.0
        
        
    }


}

