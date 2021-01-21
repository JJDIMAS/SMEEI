//
//  EnergyData.swift
//  SMEEI
//
//  Created by Mac18 on 20/01/21.
//

import Foundation

// Energy data
struct EntitiesInfo: Codable {
    let campuses: [Campus]
}

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
