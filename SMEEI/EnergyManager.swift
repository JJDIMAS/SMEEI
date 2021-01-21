//
//  EnergyManager.swift
//  SMEEI
//
//  Created by Mac18 on 20/01/21.
//

import Foundation

protocol EnergyManagerDelegate {
    func updateEntitiesInfo(campuses: [Campus])
    func handleAPIError(errorMessage: String)
    func handleDeviceError(errorMessage: String)
}

struct EnergyManager {
    
    var delegate: EnergyManagerDelegate?
    
    let baseUrl = "http://148.216.17.36:8000/api/"
    
    
    func fetchEntitiesInfo(){
        let url = "\(baseUrl)get-entities-info/"
        makeRequest(url: url, requested: "entitiesInfo")
    }
    
    
    func makeRequest(url: String, requested: String) {
        // Create url
        if let url = URL(string: url) {
            // Create  URLSessio object
            let session = URLSession(configuration: .default)
            
            var task: URLSessionDataTask
            
            if requested == "entitiesInfo" {
                // Assign task to seesion
                task = session.dataTask(with: url, completionHandler: handleEntitiesInfo(data:response:error:))
            } else {
                return
            }

            // Start task
            task.resume()
        }
    }
    
    func handleEntitiesInfo(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            delegate?.handleDeviceError(errorMessage: error!.localizedDescription)
            return
        }
        
        if let secureData = data {
            // Decode API JSON response
            if let entitiesInfoObj = self.parseEntitiesInfoJSON(entitiesInfoData: secureData) {
                delegate?.updateEntitiesInfo(campuses: entitiesInfoObj)
            } else {
                delegate?.handleAPIError(errorMessage: "The API data couldn't be get")
            }
        }
    }
    
    
    func parseEntitiesInfoJSON(entitiesInfoData: Data) -> [Campus]?{
        let decoder = JSONDecoder()
        do {
            let campuses = try decoder.decode([Campus].self, from: entitiesInfoData)
            return campuses
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
}
