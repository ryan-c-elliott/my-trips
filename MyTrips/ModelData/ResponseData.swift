//
//  ResponseData.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/10/21.
//

import Foundation


class ResponseData: Codable {
    var start: Location?
    var tripData: TripData
    
    /* * Initializers * */
    
    init() {
        self.tripData = TripData()
    }
}
