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

func mid(_ v1: Double, _ v2: Double) -> Double {
    (v1 + v2) / 2
}

func toCLLocation(_ loc: Location) -> CLLocation {
    CLLocation(latitude: loc.latitude, longitude: loc.longitude)
}

func loadJson(url: URL) -> ResponseData? {
    
    do {

        let data = try Data(contentsOf: url)
        
        let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
        return responseData
    } catch {
        print("either the data didn't load or groups couldn't be retrieved")
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
    Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
}
