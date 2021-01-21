//
//  ConsultViewController.swift
//  SMEEI
//
//  Created by Mac19 on 04/01/21.
//

import UIKit

class ConsultViewController: UIViewController {
    
    var energyManagerObj = EnergyManager()


    @IBOutlet weak var consultButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        energyManagerObj.delegate = self
        
        // Test
        energyManagerObj.fetchEntitiesInfo()

        // Do any additional setup after loading the view.
        consultButton.layer.cornerRadius = 20.0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConsultViewController: EnergyManagerDelegate {
    func updateEntitiesInfo(campuses: [Campus]) {
        DispatchQueue.main.async {
            print(campuses[0].id)
        }
    }
    
    func handleAPIError(errorMessage: String) {
        DispatchQueue.main.async {
            print("API ERROR?: \(errorMessage)")
        }
    }
    
    func handleDeviceError(errorMessage: String) {
        DispatchQueue.main.async {
            print("DEVICE ERROR?: \(errorMessage)")
        }
    }
}
