//
//  Trip.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/10/21.
//

import Foundation
import MapKit

class Trip  {
    
    var description: String?
    var start: Location
    var end: Location
    var distance: Double
    
    /* * Initializers * */
    
    convenience init(description: String?, startDate: Date, endDate: Date, route: MKRoute) {
        self.init(startDate: startDate, endDate: endDate, route: route)
        self.setDescription(description)
    }
    
    init(startDate: Date, endDate: Date, route: MKRoute) {
        self.start = Location(point: route.steps[0].polyline.points()[0], date: startDate)
        let end = route.steps.last!.polyline
        self.end = Location(point: end.points()[end.pointCount-1], date: endDate)
        self.distance = metersToMiles(route.distance)
    }
    
    init(start: CLLocation, end: CLLocation, distance: Double) {
        self.start = Location(coords: start.coordinate, date: start.timestamp)
        self.end = Location(coords: end.coordinate, date: end.timestamp)
        self.distance = metersToMiles(distance)
    }
    
    // Dummy initializer to store start date
    init(_ date: Date) {
        self.start = Location(date)
        self.end = Location()
        self.distance = 0
    }
    
    // Another dummy initializer
    convenience init() {
        self.init(Date())
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try values.decode(String?.self, forKey: .description)
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
    
    /* * Setters * */
    
    func setDescription(_ description: String?) {
        guard let description = description else {
            return
        }
        self.description = description.trimmingCharacters(in: .whitespaces) == "" ? nil : description
    }
    
}

extension Trip: Codable {
    enum CodingKeys: String, CodingKey {
        case description
        case start
        case end
        case distance
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
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
