//
//  Trip.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/10/21.
//

import Foundation
import MapKit

class Trip  {
    
    var start: Location
    var end: Location
    var distance: Double
    
    /* * Initializers * */
    
    init(startDate: Date, endDate: Date, route: MKRoute) {
        
        self.start = Location(point: route.steps[0].polyline.points()[0], date: startDate)
        self.end = Location(point: route.steps.last!.polyline.points()[0], date: endDate)
        self.distance = metersToMiles(route.distance)
    }
    
    // Dummy initializer
    init(_ date: Date) {
        self.start = Location()
        self.end = Location()
        self.distance = 0
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.start = try values.decode(Location.self, forKey: .start)
        self.end = try values.decode(Location.self, forKey: .end)
        self.distance = try values.decode(Double.self, forKey: .distance)
    }
    
    /* * Getters * */
    
    func getStartDate() -> Date {
        self.start.date
    }
    
    func getEndDate() -> Date {
        self.end.date
    }
    
}

extension Trip: Codable {
    enum CodingKeys: String, CodingKey {
        case start
        case startDate
        case end
        case endDate
        case distance
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)

        try container.encode(end, forKey: .end)
        try container.encode(distance, forKey: .distance)
    }
    
}

extension Trip: Comparable {
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        lhs.start < rhs.start
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.start == rhs.start
    }
    
    
}
