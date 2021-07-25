//
//  ModelData.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import Foundation
import CoreLocation
import MapKit

class Trip: Codable  {
    
    var startTime: Date
    var startLoc: Location
    var endTime: Date
    var endLoc: Location
    var distance: Double
    
    /* * Initializers * */
    
    init(route: MKRoute) {
        self.distance = route.distance
        self.startLoc = Location(route.steps[0].polyline.points()[0])
        self.endLoc = Location(route.steps.last!.polyline.points()[0])
        
    }
    
    /* * Setters * */
    
    func setEnd(_ end: CLLocation) {
        self.endLoc = toLocation(end)
        self.endTime = end.timestamp
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
    
    init(_ point: MKMapPoint) {
        self.init(point.coordinate)
    }
    
    init(_ location: CLLocation) {
        self.init(location.coordinate)
    }
    
    init(_ coords: CLLocationCoordinate2D) {
        self.latitude = coords.latitude
        self.longitude = coords.longitude
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
