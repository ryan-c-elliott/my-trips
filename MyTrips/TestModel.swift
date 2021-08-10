//
//  TestModel.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/9/21.
//

import Foundation
import MapKit
import CoreLocation

protocol Iterable {
    func makeIterator(start: Date, end: Date) -> TripDataIterator
}

class TripData: Codable {
    
    
    var days: [Day] = []
    var tripCount: Int = 0
    
    
    /*
     * Returs false if row or section are out of range, true otherwise
     */
    func remove(row: Int, section: Int) -> Bool {
        
        // If given section is out of range
        if section < 0 || self.days.count <= section {
            print("Couldn't remove: section \(section) out of range for count \(self.days.count)")
            return false
        }
        
        let day = self.days[section]
        
        // If given row is out of range for given section
        if !day.remove(row: row) {
            return false
        }
        
        tripCount -= 1
        
        
        // If a day is empty, remove it from days
        if day.trips.count == 0 {
            self.days.remove(at: section)
        }
        
        return true
    }
    
    /*
     * Returns the index of the given date
     * If there are no trips, nil is returned
     */
    func getIndex(_ date: Date) -> Int? {
        if self.days.count == 0 {
            return nil
        }
        return binarySearch(arr: self.days, item: Day(date))
    
    }
    
    /*
     * Adds a trip to the data structure
     * Similar to add function except instead of adding to the end it can be inserted anywhere
     * Returns true if a new day was added, false otherwise
     */
    func insert(_ trip: Trip) {
        tripCount += 1
        let n = self.days.count
        
        let day = Day(trip)
        let i = binarySearch(arr: self.days, item: day)
        if 0 < n && i < n && day == self.days[i] {  // Day already exists
            self.days[i].insert(trip)
        } else {                                    // Add a new day
            self.days.insert(day, at: i)
        }
       
       
    }
    
    /*
     * Adds a trip to the data structure
     * Returns true if a new day was added, false otherwise
     */
    func add(_ trip: Trip) {
        let day = Day(trip)
        guard let last = self.days.last, last == day else {
            // Either no trips exist or day is greater than every existing day
            self.days.append(day)
            return
        }
        last.add(trip)
        
    }
    
    
    /*
     * Returns the row and section for a given date
     * If the date doesn't exist, the next date greater is returned
     */
    func rowAndSectionFor(_ date: Date) -> (Int, Int) {
        let day = Day(date)
        let n = self.days.count
        let i = binarySearch(arr: self.days, item: day)
        
        // Date is greater than all existing dates
        if i == n {
            return (self.days[i-1].trips.count-1, i-1)
        }
        
        return (day == self.days[i] ? self.days[i].rowFor(date) : 0, i)
        
        
        
        
    }
    
    /*
     * Returns nil if index given is out of range
     */
    func get(section index: Int) -> [Trip]? {
        if index < 0 || index >= self.days.count {
            return nil
        }
        return self.days[index].trips
    }
    
    // Check if number of trips is 0 before calling
    func get(row: Int, section: Int) -> Trip? {
        guard let trips = get(section: section) else {
            return nil
        }
        return trips[row]
        
    }
    
}

extension TripData: Iterable {
    func makeIterator(start: Date, end: Date) -> TripDataIterator {
        TripDataIterator(self, start: start, end: end)
    }
}

class Day: Codable {
    
    
    let year: Int
    let month: Int
    let day: Int
    var trips: [Trip]
    
    
    init(_ trip: Trip) {
        let date: DateComponents = components(trip.getStartDate())
        self.year = date.year!
        self.month = date.month!
        self.day = date.day!
        self.trips = [trip]
    }
    
    // Dummy initializer
    init(_ date: Date) {
        let date: DateComponents = components(date)
        self.year = date.year!
        self.month = date.month!
        self.day = date.day!
        self.trips = []
    }
    
    /*
     * Returns false if row given is out of bounds, true if operation is successful
     */
    func remove(row: Int) -> Bool {
        if row < 0 || self.trips.count <= row {
            print("Couldn't remove: row \(row) out of range for count \(self.trips.count)")
            return false
        }
        self.trips.remove(at: row)
        return true
    }
    
    func add(_ trip: Trip) {
        self.trips.append(trip)
    }
    
    func insert(_ trip: Trip) {
        let i = binarySearch(arr: self.trips, item: trip)
        self.trips.insert(trip, at: i)
    }
    
    /*
     * Returns the row for a given date
     * If the date doesn't exist, the next date greater is returned
     */
    func rowFor(_ date: Date) -> Int {
        binarySearch(arr: self.trips, item: Trip(date))
    }
    
}

extension Day: Comparable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    static func < (lhs: Day, rhs: Day) -> Bool {
        if lhs.year < rhs.year {
            return true
        }
        if lhs.year > rhs.year {
            return false
        }
        if lhs.month < rhs.month {
            return true
        }
        if lhs.month > rhs.month {
            return false
        }
        if lhs.day < rhs.day {
            return true
        }
        return false
    }
    
    
    
}











class Trip: Codable  {
    
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
    
    /* * Getters * */
    
    func getStartDate() -> Date {
        self.start.date
    }
    
    func getEndDate() -> Date {
        self.end.date
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

        try container.encode(end, forKey: .end)
        try container.encode(distance, forKey: .distance)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.start = try values.decode(Location.self, forKey: .start)
        self.end = try values.decode(Location.self, forKey: .end)
        self.distance = try values.decode(Double.self, forKey: .distance)
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











class ResponseData: Codable {
    var start: Location?
    var tripData: TripData
    
    init() {
        self.tripData = TripData()
    }

}



struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let date: Date
    
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

