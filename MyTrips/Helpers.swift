//
//  Helpers.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import Foundation
import CoreLocation

func toLocation(_ loc: CLLocation) -> Location {
    let coords = loc.coordinate
    return Location(latitude: coords.latitude, longitude: coords.longitude)
}

func toCLLocation(_ loc: Location) -> CLLocation {
    CLLocation(latitude: loc.latitude, longitude: loc.longitude)
}
