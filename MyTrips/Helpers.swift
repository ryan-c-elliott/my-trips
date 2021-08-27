//
//  Helpers.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import Foundation
import CoreLocation
import MapKit

func toLocation(_ loc: CLLocation) -> Location {
    let coords = loc.coordinate
    return Location(latitude: coords.latitude, longitude: coords.longitude, date: Date())
}

func mid(_ v1: Double, _ v2: Double) -> Double {
    (v1 + v2) / 2
}

func toCLLocation(_ loc: Location) -> CLLocation {
    CLLocation(latitude: loc.latitude, longitude: loc.longitude)
}

func toCLLocation(_ loc: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: loc.latitude, longitude: loc.longitude)
}

func loadJson(url: URL) -> ResponseData? {
    do {

        let data = try Data(contentsOf: url)
        
        let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
        return responseData
    } catch {
        print("either the data didn't load or trips couldn't be retrieved")
    }
    
    return nil
}

// URL for data in Application Storage
func getURL(filename: String) -> URL? {

    do {
        let url = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(filename)
        return url
    } catch {
        print("url couldn't be retrieved")
    }
    return nil
}

func write<T: Encodable>(url: URL, data: T) {
    
    do {

        try JSONEncoder().encode(data)
            .write(to: url)
    } catch {
        print("json failed to encode")
    }
}

func tripsWrite(data: ResponseData) {
    write(url: getURL(filename: "data")!, data: data)
}

func toJson<T: Encodable>(_ object: T) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(object)
        return String(data: jsonData, encoding: String.Encoding.utf8)!
    } catch {
        print("object couldn't be encoded")
    }
    return nil
    
}
/*
func print(_ data: ResponseData) {
    for trip in data.trips {
        print("Distance: \(trip.distance)")
        print("Start: \(trip.startDate)")
        print("End: \(trip.endDate)")
        print()
    }
    
}
 */

func components(_ date: Date) -> DateComponents {
    components(date, components: [.year, .month, .day])
}

func components(_ date: Date, components: Set<Calendar.Component>) -> DateComponents {
    Calendar(identifier: .gregorian).dateComponents(components, from: date)
}


func metersToMiles(_ distance: Double) -> Double {
    distance * 0.000621
}

/*
 * Returns index of where the item should be inserted
 * If the item doesn't already exist in the array, index of next highest is returned
 */
func binarySearch<T: Comparable>(arr: [T], item: T) -> Int {
    let n = arr.count
    
    // If empty or less than first
    if n == 0 || item < arr.first! {
        return 0
    }
    
    // If greater than last
    if arr.last! < item {
        return n
    }
    
    // Search
    var l: Int = 0
    var r: Int = n
    while l < r {
        let mid: Int = (l + r) / 2
        if arr[mid] == item {
            return mid
        }
        if arr[mid] < item {
            l = mid + 1
        } else {
            r = mid
        }
        
    }
    
    return l
}

func route(start: CLLocation, end: CLLocation, onSuccess: @escaping (MKRoute) -> (), onFailure: @escaping () -> ()) {
    // Convert to MKPlacemark
    let request = MKDirections.Request()
    let source = MKPlacemark(coordinate: start.coordinate)
    let dest = MKPlacemark(coordinate: end.coordinate)
    request.source = MKMapItem(placemark: source)
    request.destination = MKMapItem(placemark: dest)
    request.transportType = MKDirectionsTransportType.automobile
    request.requestsAlternateRoutes = false
    
    // Find directions
    let directions = MKDirections(request: request)

    directions.calculate { (response, error) in
        if let route = response?.routes.first {
            onSuccess(route)
        } else {
            onFailure()
            print("couldn't calculate route")
        }
    }
}
