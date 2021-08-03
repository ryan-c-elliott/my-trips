//
//  ModelData.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import Foundation
import CoreLocation
import MapKit

class Components: Codable {
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
        Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: date)
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
        
        // If the given section is out of bounds, returns the next closest
        var section = section
        if section >= self.sectionCount {
            section = sectionCount-1
        }
        if section < 0 {
            section = 0
        }
        
 
        var i = 0
        var sectionCount = self.years[i].sectionCount
        while section >= sectionCount {
            i += 1
            sectionCount += self.years[i].sectionCount
        }
        sectionCount -= self.years[i].sectionCount
        return self.years[i].get(section: section - sectionCount)
    }
    
    // Check if number of trips is 0 before calling
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


class Year: Codable {

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

class Month: Codable {
    
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

class Day: Codable {
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



class Trip: Codable  {
    
    var start: Location
    var startDate: Date
    var end: Location
    var endDate: Date
    var distance: Double
    
    /* * Initializers * */
    
    init(startDate: Date, endDate: Date, route: MKRoute) {
        
        self.start = Location(route.steps[0].polyline.points()[0])
        self.startDate = startDate
        self.end = Location(route.steps.last!.polyline.points()[0])
        self.endDate = endDate
        self.distance = route.distance
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
        try container.encode(startDate, forKey: .startDate)
        try container.encode(end, forKey: .end)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(distance, forKey: .distance)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.start = try values.decode(Location.self, forKey: .start)
        self.startDate = try values.decode(Date.self, forKey: .startDate)
        self.end = try values.decode(Location.self, forKey: .end)
        self.endDate = try values.decode(Date.self, forKey: .endDate)
        self.distance = try values.decode(Double.self, forKey: .distance)
    }
    
}




struct ResponseData: Codable {
    var components: Components
}


struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    init(_ point: MKMapPoint) {
        self.init(point.coordinate)
    }
    
    init(_ location: CLLocation) {
        self.init(location.coordinate)
    }
    
    init(_ coords: CLLocationCoordinate2D) {
        self.latitude = coords.latitude
        self.longitude = coords.longitude
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
