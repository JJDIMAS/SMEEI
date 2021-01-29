//
//  ViewController.swift
//  SMEEI
//
//  Created by Mac19 on 30/12/20.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {



  
   
   
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var accessButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        accessButton.layer.cornerRadius = 20.0
        ValidarSesion()
        }
    func ValidarSesion(){
        if Auth.auth().currentUser != nil {
            // User is signed in.
            performSegue(withIdentifier: "MainToConsult", sender: self)
        }
    }
    
    @IBAction func accessButton(_ sender: UIButton) {
        if let email = mailTextField.text , let password = passwordTextField.text {
                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                           if let e = error {
                               print(e.localizedDescription)
                               if email == "" , password == "" {
                                   self?.alerta(mensaje: "Los campos no pueden estar vacíos")
                               }
                               if e.localizedDescription.contains("invalid"){
                                   self?.alerta(mensaje: "Contraseña incorrecta")
                               }else if e.localizedDescription.contains("email"){
                                   self?.alerta(mensaje: "El correo es inválido")
                               }else if e.localizedDescription.contains("record"){
                                   self?.alerta(mensaje: "Este usuario no existe")
                               }
                           }else{
                               if let respuestaFirebase = authResult {
                                   print("\(respuestaFirebase.user) inicio sesión correctamente")
                                   self?.performSegue(withIdentifier: "MainToConsult", sender: self)
                               }
                           }
                       }
                   }
                }
    
    @IBAction func registerButton(_ sender: UIButton) {
        performSegue(withIdentifier: "MainToRegister", sender: self)
    }
    func alerta(mensaje : String){
        let alerta = UIAlertController(title: "Error", message: "Verifica los datos proporcionados. \n \(mensaje)", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
