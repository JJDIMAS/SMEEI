//
//  RegisterViewController.swift
//  SMEEI
//
//  Created by Mac19 on 04/01/21.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.layer.cornerRadius = 20.0
        
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
        if (mailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == ""){
            alerta(mensaje: "Los campos no pueden estar vacíos")
        }else{
            if let email = mailTextField.text, let password = passwordTextField.text{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        print(e.localizedDescription)
                        if(e.localizedDescription.contains("password")){
                            self.alerta(mensaje: "La contraseña debe tener al menos 6 caracteres")
                        }else if e.localizedDescription.contains("email") {
                            self.alerta(mensaje: "Ingresa un correo válido")
                        }
                        
                    }else{
                        //Ya podemos registrar el usuario
                        self.performSegue(withIdentifier: "RegisterToConsult", sender: self)
                        
                    }
                }
            }
        }

    }
    
    func alerta (mensaje : String ){
        let alerta = UIAlertController(title: "Error", message: "Verifica los datos proporcionados. \n \(mensaje)", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
