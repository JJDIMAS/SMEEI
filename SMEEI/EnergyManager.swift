//
//  EnergyManager.swift
//  SMEEI
//
//  Created by Mac18 on 20/01/21.
//

import Foundation

protocol EnergyManagerDelegate {
    func getCampusesInfo(campuses: [Campus])
    func getLogsInfo(logs: Result)
    func handleAPIError(errorMessage: String)
    func handleDeviceError(errorMessage: String)
}

struct EnergyManager {
    
    var delegate: EnergyManagerDelegate?
    
    let baseUrl = "http://148.216.17.36:8000/api/"
    
    func getEntitiesInfo(){
        let url = "\(baseUrl)get-entities-info/"
        makeEntitiesRequest(url: url)
    }
    
    func getLogsInfo(requestBody: LogsRequestBody){
        let url = "\(baseUrl)get-logs-info/"
        makeLogsRequest(url: url, requestBody: requestBody)
    }
    
    func makeEntitiesRequest(url: String) {
        // Create url
        if let url = URL(string: url) {
            // Create  URLSessio object
            let session = URLSession(configuration: .default)
            
            var task: URLSessionDataTask
            
            // Assign task to seesion
            task = session.dataTask(with: url, completionHandler: handleEntitiesInfo(data:response:error:))

            // Start task
            task.resume()
        }
    }
    
    func makeLogsRequest(url: String, requestBody: LogsRequestBody) {
        // Create url
        if let components = URLComponents(string: url) {
            let encoder = JSONEncoder()
            var bodyData: Data
            
            do {
                bodyData = try encoder.encode(requestBody)
            } catch let error{
                print(error.localizedDescription)
                return
            }
                        
            // Create URLSession object
            var request = URLRequest(url: components.url!)
            
            // Set headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // Set HTTP method
            request.httpMethod = "POST"
            
            // Set request JSON body
            request.httpBody = bodyData
                        
            // Create URLSession object
            let task = URLSession.shared.dataTask(with: request, completionHandler: handleLogsInfo(data:response:error:))
            
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
            if let entitiesInfoObj = self.parseEntitiesInfoJSON(entitiesInfoData: secureData) {
                delegate?.getCampusesInfo(campuses: entitiesInfoObj)
            } else {
                delegate?.handleAPIError(errorMessage: "The API data couldn't be get")
            }
        }
    }
    
    func handleLogsInfo(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            delegate?.handleDeviceError(errorMessage: error!.localizedDescription)
            return
        }
        
        if let secureData = data {
            if let logsInfoObj = self.parseLogsInfoJSON(logsInfoData: secureData) {
                delegate?.getLogsInfo(logs: logsInfoObj)
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
    
    func parseLogsInfoJSON(logsInfoData: Data) -> Result?{
        let decoder = JSONDecoder()
        
        do {
            let logs = try decoder.decode(Result.self, from: logsInfoData)
            return logs
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
}
