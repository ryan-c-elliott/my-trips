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
    
    func rowAndSectionFor(_ date: Date) -> (Int, Int) {
        let components = self.components(date)
        let year = components.year!
        var i = 0
        var sections = 0
        while i < self.years.count && self.years[i].year < year {
            sections += self.years[i].sectionCount
            i += 1
        }
        if i == self.years.count {
            return (0, sections)
        }
        
        let (row, section) = self.years[i].rowAndSectionFor(date, components: components)
        return (row, section + sections)
        
        
        
    }
    
    func get(section: Int) -> [Trip] {
        /*
        if section < 0 || section >= self.sectionCount {
            return nil
        }
 */
        var i = 0
        var sectionCount = self.years[i].sectionCount
        while section >= sectionCount {
            i += 1
            sectionCount += self.years[i].sectionCount
        }
        sectionCount -= self.years[i].sectionCount
        return self.years[i].get(section: section - sectionCount)
    }
    
    func get(row: Int, section: Int) -> Trip {
        /*
        if let trips = get(section: section), row > 0 && row < trips.count {
            return trips[row]
        }
        return nil
 */
        return get(section: section)[row]
    }
}


class Year {

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
    
    func rowAndSectionFor(_ date: Date, components: DateComponents) -> (Int, Int) {
        let month = components.month!
        var i = 0
        var sections = 0
        while i < self.months.count && self.months[i].month < month {
            sections += self.months[i].days.count
            i += 1
        }
        if i == self.months.count {
            return (0, sections)
        }
        
        let (row, section) = self.months[i].rowAndSectionFor(date, components: components)
        return (row, section + sections)
    }
    
    func get(section: Int) -> [Trip] {
        var i = 0
        var sectionCount = self.months[i].days.count
        while section >= sectionCount {
            i += 1
            sectionCount += self.months[i].days.count
        }
        sectionCount -= self.months[i].days.count
        return self.months[i].get(section: section - sectionCount)
    }
    
}

class Month {
    
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
        let day = components.day!
        
        
        if let last = self.days.last, last.day == day {
            last.add(trip)
            return false
        } else {
            self.days.append(Day(day: day))
            self.days.last!.add(trip)
            return true
        }
    }
    
    func rowAndSectionFor(_ date: Date, components: DateComponents) -> (Int, Int) {
        let day = components.day!
        var i = 0
        var sections = 0
        while i < self.days.count && self.days[i].day < day {
            sections += 1
            i += 1
        }
        if i == self.days.count {
            return (0, sections)
        }
        
        return (self.days[i].rowFor(date), sections)
    }
    
    func get(section: Int) -> [Trip] {
        return self.days[section].trips
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
    
    func rowFor(_ date: Date) -> Int {
        var i = 0
        var rows = 0
        while i < self.trips.count && self.trips[i].startDate < date {
            rows += 1
            i += 1
        }
        return rows
    }
    
}

