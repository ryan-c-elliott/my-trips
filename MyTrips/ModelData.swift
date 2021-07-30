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
    
    var start: Location
    var startDate: Date
    var end: Location
    var endDate: Date
    var distance: Double
    
    /* * Initializers * */
    
    init(startDate: Date, endDate: Date, route: MKRoute) {
        
        self.start = Location(route.steps[0].polyline.points()[0])
        self.startDate = startDate
        self.end = Location(route.steps.last!.polyline.points()[0])
        self.endDate = endDate
        self.distance = route.distance
    }
    
    
    /* * Codable * */
    
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
        try container.encode(startDate, forKey: .startDate)
        try container.encode(end, forKey: .end)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(distance, forKey: .distance)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.start = try values.decode(Location.self, forKey: .start)
        self.startDate = try values.decode(Date.self, forKey: .startDate)
        self.end = try values.decode(Location.self, forKey: .end)
        self.endDate = try values.decode(Date.self, forKey: .endDate)
        self.distance = try values.decode(Double.self, forKey: .distance)
    }
    
}




struct ResponseData: Codable {
    var trips: [Trip]
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
