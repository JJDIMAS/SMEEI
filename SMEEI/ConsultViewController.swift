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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var consultButton: UIButton!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    // This object allows us to access all the methods to access Energy API info and its delegates.
    var energyManagerObj = EnergyManager()
    
    // Date format
    var dateFormatter = DateFormatter()
    
    // This variable contains nested info about campuses: It is a list of campuses, each campus has a list of buildings and each building has a list of circuits (see EnergyEntitiesInfoData.swift for more info).
    var campuses: [Campus] = []
    var dataEntries : [Average] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set search capabilitie off
        CampusesDropDown.isSearchEnable = false
        BuildingsDropDown.isSearchEnable = false
        CicuitsDropDown.isSearchEnable = false
    
        //Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Set maximium date as today
        let date = Date()
        datePicker.maximumDate = date
        
        // Delegates.
        energyManagerObj.delegate = self
        
        // It makes an API request to get entities info, and delegates errors and response data.
        energyManagerObj.getEntitiesInfo()

        // Do any additional setup after loading the view.
        consultButton.layer.cornerRadius = 20.0
        
        setSelectionDropdownUpdated()
    }
    
    
    @IBAction func consultButton(_ sender: UIButton) {
        // It makes an API request to get logs info, and delegates errors and response data.
        var period: String
        
        switch periodSegmentedControl.selectedSegmentIndex {
        case 0:
            period = "week"
        case 1:
            period = "month"
        default:
            period = "year"
        }
        
        let dateString = dateFormatter.string(from: datePicker.date)
        let campusId = campuses[CampusesDropDown.selectedIndex!].id
        let buildingId = campuses[CampusesDropDown.selectedIndex!].buildings[BuildingsDropDown.selectedIndex!].id
        let circuitId = campuses[CampusesDropDown.selectedIndex!].buildings[BuildingsDropDown.selectedIndex!].circuits[CicuitsDropDown.selectedIndex!].id

        requestFormData(period: period, date: dateString, campusId: campusId, buildingId: buildingId, circuitId: circuitId)
        
        UserDefaults.standard.set(period, forKey: "period")
        UserDefaults.standard.set(dateString, forKey: "date")
        UserDefaults.standard.set(campusId, forKey: "campusId")
        UserDefaults.standard.set(buildingId, forKey: "buildingId")
        UserDefaults.standard.set(circuitId, forKey: "circuitId")
    }
    
    func requestFormData(period: String, date: String, campusId: Int, buildingId: Int, circuitId: Int) {
        // "Id" is the value that must be passed as parameter for campus, building and circuit.
        let logsRequestBodyObj = LogsRequestBody(
            date: date,
            period: period,
            campus: campusId,
            building: buildingId,
            circuit: circuitId
        )
        
        energyManagerObj.getLogsInfo(requestBody: logsRequestBodyObj)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "consultToChart" {
            let destino = segue.destination as! UITabBarController
            let barCtrl = destino.viewControllers![0] as! BarChartViewController
            let PieCtrl = destino.viewControllers![1] as! PieChartViewController
            let LineCtrl = destino.viewControllers![2] as! LineChartViewController
            barCtrl.dataEntries = dataEntries
            PieCtrl.dataEntries = dataEntries
            LineCtrl.dataEntries = dataEntries
        }
    }
}

extension ConsultViewController: EnergyManagerDelegate {
    func getCampusesInfo(campuses: [Campus]) {
        // This delegate intializes the "campuses" variable (all the data needed data to fill the "form").
        // This also sets the initial values for the "CampusesDropDown", since this data needs to be filled immediately when the view loads.
        DispatchQueue.main.async {
            self.campuses = campuses
            
            // We'll select the first campus, its first building and its first circuit as the default values for the dropdowns (then, the user change this values by selecting items)
            self.updateCampusesDropdown()
        }
    }
    
    func getLogsInfo(logs: Result) {
        DispatchQueue.main.async {
            self.dataEntries = logs.period_result
            //Store stats for widget feed
            UserDefaults.standard.set(logs.total_result.maximum, forKey: "max_value")
            UserDefaults.standard.set(logs.total_result.minimum, forKey: "min_value")
            UserDefaults.standard.set(logs.total_result.average, forKey: "average")
            self.performSegue(withIdentifier: "consultToChart", sender: self)
        }
    }
    
    func handleAPIError(errorMessage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Sin datos", message: "No se encontraron datos para la consulta realizada", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func handleDeviceError(errorMessage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Hubo un error con su dispositivo. Intente de nuevo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension ConsultViewController {
    func updateCampusesDropdown() {
        // Campuses names and ids (as in the API to make a request)
        var campusesNames: [String] = []
        var campusesIds: [Int] = []
        
        for campus in campuses {
            campusesNames.append(campus.name)
            campusesIds.append(campus.id)
        }
        
        // Set campuses dropdown info
        CampusesDropDown.optionArray = campusesNames
        CampusesDropDown.optionIds = campusesIds
        
        // Update text in campuses dropdown
        CampusesDropDown.selectedIndex = 0
        self.CampusesDropDown.text = self.campuses[0].name

        updateBuildingsDropdown(campusIndex: 0)
    }
    
    func updateBuildingsDropdown(campusIndex: Int) {
        // Buildings names and ids (as in the API to make a request)
        var buildingsNames: [String] = []
        var buildingsIds: [Int] = []
        
        for building in campuses[campusIndex].buildings {
            buildingsNames.append(building.name)
            buildingsIds.append(building.id)
        }
        
        // Set buildings dropdown info
        BuildingsDropDown.optionArray = buildingsNames
        BuildingsDropDown.optionIds = buildingsIds
        
        // Update text in buldings dropdown
        self.BuildingsDropDown.selectedIndex = 0
        self.BuildingsDropDown.text = self.campuses[campusIndex].buildings[0].name
        
        // Set the default circuit to be seletect after filling the buildings dropdown values.
        updateCircuitsDropdown(campusIndex: campusIndex, buildingIndex: 0)
    }
    
    func updateCircuitsDropdown(campusIndex: Int, buildingIndex: Int) {
        // Circuits names and ids (as in the API to make a request)
        var circuitsNames: [String] = []
        var circuitsIds: [Int] = []
        
        for circuit in campuses[campusIndex].buildings[buildingIndex].circuits {
            circuitsNames.append(circuit.name)
            circuitsIds.append(circuit.id)
        }
        
        // Set circuits dropdown info
        CicuitsDropDown.optionArray = circuitsNames
        CicuitsDropDown.optionIds = circuitsIds
        
        // Update text in circuits dropdown
        self.CicuitsDropDown.selectedIndex = 0
        self.CicuitsDropDown.text = self.campuses[campusIndex].buildings[buildingIndex].circuits[0].name
    }
    
    func setSelectionDropdownUpdated() {
        CampusesDropDown.didSelect{(selectedText , index ,id) in
            self.updateBuildingsDropdown(campusIndex: index)
        }
        
        BuildingsDropDown.didSelect{(selectedText , index ,id) in
            let campusIndex = self.CampusesDropDown.selectedIndex!
            self.updateCircuitsDropdown(campusIndex: campusIndex, buildingIndex: index)
        }
    }
}

extension ConsultViewController {
    // Shake gesture to automatically replay last request/query.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            // If one key exists, all other keys should exist, so there is not need to test each.
            if UserDefaults.standard.object(forKey: "period") != nil {
                requestFormData(
                    period: UserDefaults.standard.string(forKey: "period") ?? "",
                    date: UserDefaults.standard.string(forKey: "date") ?? "",
                    campusId: UserDefaults.standard.integer(forKey: "campusId"),
                    buildingId: UserDefaults.standard.integer(forKey: "buildingId"),
                    circuitId: UserDefaults.standard.integer(forKey: "circuitId")
                )
            } else {
                let alert = UIAlertController(title: "Error", message: "Debe realizar al menos una consulta antes de utilizar esta función", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
