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
    
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    // This object allows us to access all the methods to access Energy API info and its delegates.
    var energyManagerObj = EnergyManager()
    
    //Date format
    var dateFormatter = DateFormatter()
    
    // This variable contains nested info about campuses: It is a list of campuses, each campus has a list of buildings and each building has a list of circuits (see EnergyEntitiesInfoData.swift for more info).
    var campuses: [Campus] = []
    var dataEntries : [Average] = []
    

    @IBOutlet weak var consultButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
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
        //Clear out our data entries
        //dataEntries.removeAll()
        
        print("Something")
       
        // "Id" is the value that must be passed as parameter for campus, building and circuit.
        let logsRequestBodyObj = LogsRequestBody(
            date: dateFormatter.string(from: datePicker.date),
            period: period,
            campus: campuses[CampusesDropDown.selectedIndex!].id,
            building: campuses[CampusesDropDown.selectedIndex!].buildings[BuildingsDropDown.selectedIndex!].id,
            circuit: campuses[CampusesDropDown.selectedIndex!].buildings[BuildingsDropDown.selectedIndex!].circuits[CicuitsDropDown.selectedIndex!].id
        )
        
        energyManagerObj.getLogsInfo(requestBody: logsRequestBodyObj)
        // performSegue(withIdentifier: "consultToChart", sender: self)
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
            
            // Default start index (just for the first time, then these are updated when user selects the items)
            let defaultIndex = 0
            
            self.updateCampusesDropdown()
            
            // Default dropdowns selected items (just for the first time, then these are updated when user selects the items)
            self.CampusesDropDown.selectedIndex = defaultIndex
            self.BuildingsDropDown.selectedIndex = defaultIndex
            self.CicuitsDropDown.selectedIndex = defaultIndex
            
            // Default drodowns texts (just for the first time, then these are updated when user selects the items)
            self.CampusesDropDown.text = self.campuses[defaultIndex].name
            self.BuildingsDropDown.text = self.campuses[defaultIndex].buildings[defaultIndex].name
            self.CicuitsDropDown.text = self.campuses[defaultIndex].buildings[defaultIndex].circuits[defaultIndex].name
        }
    }
    
    func getLogsInfo(logs: Result) {
        DispatchQueue.main.async {
            self.dataEntries = logs.period_result
            // Handle logs response
            print("Minimum of period: \(logs.total_result.minimum)")
            print("Maxmimum of period: \(logs.total_result.maximum)")
            print("Average of period: \(logs.total_result.average)")
            
            for average in logs.period_result {
                print("Average per period item: \(average.average)")
            }
            
            self.performSegue(withIdentifier: "consultToChart", sender: self)

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
        
        // Default dropdowns selected items (just for the first time, then these are updated when user selects the items)
        CampusesDropDown.selectedIndex = 0

        
        // Set the default building to be seletect after filling the campuses dropdown values.
        updateBuildingsDropdown(campusIndex: 0)
        
        // Default drodowns texts (just for the first time, then these are updated when user selects the items)
        self.CampusesDropDown.text = self.campuses[0].name
    }
    
    func updateBuildingsDropdown(campusIndex: Int) {
        // Buildings names and ids (as in the API to make a request)
        var buildingsNames: [String] = []
        var buildingsIds: [Int] = []
        
        for building in campuses[campusIndex].buildings {
            buildingsNames.append(building.name)
            buildingsIds.append(building.id)
            print("Building: \(building.name)")
        }
        
        // Set buildings dropdown info
        BuildingsDropDown.optionArray = buildingsNames
        BuildingsDropDown.optionIds = buildingsIds
        
        self.BuildingsDropDown.selectedIndex = 0
        
        // Set the default circuit to be seletect after filling the buildings dropdown values.
        updateCircuitsDropdown(campusIndex: campusIndex, buildingIndex: 0)
        
        self.BuildingsDropDown.text = self.campuses[campusIndex].buildings[0].name
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
        
        self.CicuitsDropDown.selectedIndex = 0
        
        self.CicuitsDropDown.text = self.campuses[campusIndex].buildings[buildingIndex].circuits[0].name
    }
    
    func setSelectionDropdownUpdated() {
        CampusesDropDown.didSelect{(selectedText , index ,id) in
            let selectedCampus = self.campuses[index]
            print("(Dropdown) Campus: \(selectedText), Index: \(index), Id: \(id)")
            print("(API Values) Campus name: \(selectedCampus.name), Campus id: \(selectedCampus.id)")
            self.updateBuildingsDropdown(campusIndex: index)
        }
        
        BuildingsDropDown.didSelect{(selectedText , index ,id) in
            let campusIndex = self.CampusesDropDown.selectedIndex!
            let selectedBuilding = self.campuses[campusIndex].buildings[index]
            print("(Dropdown) Building: \(selectedText), Index: \(index), Id: \(id)")
            print("(API Values) Building name: \(selectedBuilding.name), Campus id: \(selectedBuilding.id)")
            self.updateCircuitsDropdown(campusIndex: campusIndex, buildingIndex: index)
        }
    }
}
