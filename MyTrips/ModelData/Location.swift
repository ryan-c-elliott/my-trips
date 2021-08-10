//
//  Location.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/10/21.
//

import Foundation
import MapKit

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let date: Date
    
    /* * Initializers * */
    
    // Dummy initializer
    init() {
        self.latitude = 0
        self.longitude = 0
        self.date = Date()
    }
    
    init(point: MKMapPoint, date: Date) {
        self.init(coords: point.coordinate, date: date)
    }
    
    init(location: CLLocation) {
        self.init(coords: location.coordinate, date: location.timestamp)
    }
    
    init(coords: CLLocationCoordinate2D, date: Date) {
        self.latitude = coords.latitude
        self.longitude = coords.longitude
        self.date = date
    }
    
    init(latitude: Double, longitude: Double, date: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
}

extension Location: Comparable {
    static func < (lhs: Location, rhs: Location) -> Bool {
        lhs.date < rhs.date
    }
    
    
}
