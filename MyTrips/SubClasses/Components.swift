//
//  Components.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/1/21.
//

import Foundation

class Components {
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var years: [Year] = []
    var sectionCount: Int = 0
    var tripCount: Int = 0
    
    /*
     * Adds a trip to the data structure
     * Returns true if a new day was added, false otherwise
     */
    func add(_ trip: Trip) {
        
        self.tripCount += 1
        let components = self.components(trip.startDate)
        let year = components.year!
        
        // Determine if a there needs to be a new section
        var res = false
        if let last = self.years.last, last.year == year {
            res = last.add(trip, components: components)
        } else {
            self.years.append(Year(year: year))
            res = self.years.last!.add(trip, components: components)
        }
        
        // If there does need to be a new section, increment sectionCount
        if res {
            self.sectionCount += 1
        }
        
    }
    
    func components(_ date: Date) -> DateComponents {
        self.calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    func sectionFor(_ date: Date) -> Int {
        
    }
}


class Year {
    //let delegate: Components
    let year: Int
    var months: [Month] = []
    var sectionCount: Int = 0
    var tripCount: Int = 0
    
    init(year: Int) {
        self.year = year
    }
    
    /*
     * Adds a trip to the data structure
     * Returns true if a new day was added, false otherwise
     */
    func add(_ trip: Trip, components: DateComponents) -> Bool {
        
        self.tripCount += 1
        let month = components.month!
        
        var res = false
        if let last = self.months.last, last.month == month {
            res = last.add(trip, components: components)
        } else {
            self.months.append(Month(month: month))
            res = self.months.last!.add(trip, components: components)
        }
        
        // If there does need to be a new section, increment sectionCount
        if res {
            self.sectionCount += 1
        }
        
        
        return res
    }
}

class Month {
    //let delegate: Components
    let month: Int
    var days: [Day] = []
    var tripCount: Int = 0
    
    init(month: Int) {
        self.month = month
    }
    
    /*
     * Adds a trip to the data structure
     * Returns true if a new day was added, false otherwise
     */
    func add(_ trip: Trip, components: DateComponents) -> Bool {
        
        self.tripCount += 1
        let day = components.month!
        
        
        if let last = self.days.last, last.day == day {
            last.add(trip)
            return false
        } else {
            self.days.append(Day(day: day))
            self.days.last!.add(trip)
            return true
        }
    }
}

class Day {
    //let delegate: Components
    let day: Int
    var trips: [Trip] = []
    
    init(day: Int) {
        self.day = day
    }
    
    /*
     * Adds a trip to the data structure
     */
    func add(_ trip: Trip) {
        trips.append(trip)
    }
    
    
}

