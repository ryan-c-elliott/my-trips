//
//  ModelData.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import Foundation
import CoreLocation

class Trip: Codable  {
    
    var startTime: Date = Date()
    var startLoc: Location
    var endTime: Date? = nil
    var endLoc: Location? = nil
    
    /* * Initializers * */
    
    init(_ start: CLLocation) {
        self.startLoc = toLocation(start)
        
    }
    
    /* * Setters * */
    
    func setEndTime(_ end: Date) {
        self.endTime = end
    }
    
    func setEndLoc(_ end: CLLocation) {
        self.endLoc = toLocation(end)
    }
    
    /* * Codable * */
    
    enum CodingKeys: String, CodingKey {
        case startTime
        case startLoc
        case endTime
        case endLoc
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(startLoc, forKey: .startLoc)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(endLoc, forKey: .endLoc)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.startTime = try values.decode(Date.self, forKey: .startTime)
        self.startLoc = try values.decode(Location.self, forKey: .startLoc)
        self.endTime = try values.decode(Date.self, forKey: .endTime)
        self.endLoc = try values.decode(Location.self, forKey: .endLoc)
    }
    
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
}
