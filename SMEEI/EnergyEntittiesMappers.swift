//
//  EnergyData.swift
//  SMEEI
//
//  Created by Mac18 on 20/01/21.
//

import Foundation

// Entities info data (campuses)
struct Campus: Codable {
    let id: Int
    let name: String
    let buildings: [Building]
}

struct Building: Codable {
    let id: Int
    let name: String
    let circuits: [Circuit]
}

struct Circuit: Codable {
    let id: Int
    let name: String
}


// Logs request body
struct LogsRequestBody: Codable {
    var date: String
    var period: String
    var campus: Int
    var building: Int
    var circuit: Int
    
    init(date: String, period: String, campus: Int, building: Int, circuit: Int) {
        self.date = date
        self.period = period
        self.campus = campus
        self.building = building
        self.circuit = circuit
    }
}

// Log response body
struct Result: Codable {
    let total_result: TotalResult
    let period_result: [Average]
}

struct TotalResult: Codable {
    let minimum: Float
    let maximum: Float
    let average: Float
}

struct Average: Codable {
    let average: Float
}
