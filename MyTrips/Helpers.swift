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
