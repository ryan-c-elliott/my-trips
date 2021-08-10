//
//  Day.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/10/21.
//

import Foundation

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
