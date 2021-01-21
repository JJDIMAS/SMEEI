//
//  ConsultViewController.swift
//  SMEEI
//
//  Created by Mac19 on 04/01/21.
//

import UIKit

import iOSDropDown

class ConsultViewController: UIViewController {
    
    @IBOutlet weak var CampusesDropDown: DropDown!
    @IBOutlet weak var BuildingsDropDown: DropDown!
    @IBOutlet weak var CicuitsDropDown: DropDown!
    
    // This object allows us to access all the methods to access Energy API info and its delegates.
    var energyManagerObj = EnergyManager()
    
    // This variable contains nested info about campuses: It is a list of campuses, each campus has a list of buildings and each building has a list of circuits (see EnergyEntitiesInfoData.swift for more info).
    var campuses: [Campus] = []

    @IBOutlet weak var consultButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates.
        energyManagerObj.delegate = self
        
        // It makes an API request to get entities info, and delegates errors and response data.
        energyManagerObj.getEntitiesInfo()
        
        // It makes an API request to get logs info, and delegates errors and response data.
        let logsRequestBodyObj = LogsRequestBody(date: "2020-10-10", period: "week", campus: 1, building: 2, circuit: 3)
        energyManagerObj.getLogsInfo(requestBody: logsRequestBodyObj)

        // Do any additional setup after loading the view.
        consultButton.layer.cornerRadius = 20.0
    }
}

extension ConsultViewController: EnergyManagerDelegate {
    func getCampusesInfo(campuses: [Campus]) {
        // This delegate intializes the "campuses" variable (all the data needed data to fill the "form").
        // This also sets the initial values for the "CampusesDropDown", since this data needs to be filled immediately when the view loads.
        DispatchQueue.main.async {
            self.campuses = campuses
            
            // We'll select the first campus, its first building and its first circuit as the default values for the dropdowns (then, the user change this values by selecting items)
            
            // Default start index
            let defaultIndex = 0
            
            for campus in self.campuses {
                self.CampusesDropDown.optionArray.append(campus.name)
                self.CampusesDropDown.optionIds?.append(campus.id)
            }
            
            for building in self.campuses[defaultIndex].buildings {
                self.BuildingsDropDown.optionArray.append(building.name)
                self.BuildingsDropDown.optionIds?.append(building.id)
            }
            
            for circuit in self.campuses[defaultIndex].buildings[defaultIndex].circuits {
                self.CicuitsDropDown.optionArray.append(circuit.name)
                self.CicuitsDropDown.optionIds?.append(circuit.id)
            }
            
            // Default selected items
            self.CampusesDropDown.selectedIndex = defaultIndex
            self.BuildingsDropDown.selectedIndex = defaultIndex
            self.CicuitsDropDown.selectedIndex = defaultIndex
            
            // Default text for the dropdowns
            self.CampusesDropDown.text = self.campuses[defaultIndex].name
            self.BuildingsDropDown.text = self.campuses[defaultIndex].buildings[defaultIndex].name
            self.CicuitsDropDown.text = self.campuses[defaultIndex].buildings[defaultIndex].circuits[defaultIndex].name
        }
    }
    
    func getLogsInfo(logs: Result) {
        DispatchQueue.main.async {
            // Handle logs response
            print("Minimum of period: \(logs.total_result.minimum)")
            print("Maxmimum of period: \(logs.total_result.maximum)")
            print("Average of period: \(logs.total_result.average)")
            
            for average in logs.period_result {
                print("Average per period item: \(average.average)")
            }
        }
    }
    
    func handleAPIError(errorMessage: String) {
        DispatchQueue.main.async {
            // Properly implement API error
            print("API ERROR?: \(errorMessage)")
        }
    }
    
    func handleDeviceError(errorMessage: String) {
        DispatchQueue.main.async {
            // Properly implement "device" error
            print("DEVICE ERROR?: \(errorMessage)")
        }
    }
}
