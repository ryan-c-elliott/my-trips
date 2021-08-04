//
//  ComponentsIterator.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/3/21.
//

import Foundation

protocol TripIterator {
    func next() -> Trip?
}

class ComponentsIterator: TripIterator {
    
    private let components: Components
    private let start: Date
    private let end: Date
    private var year: Int? = nil
    private var month: Int? = nil
    private var day: Int? = nil
    private var trip: Int? = nil
    
    init(_ components: Components, start: Date, end: Date) {
        self.components = components
        self.start = start
        self.end = end
        if let (year, month, day) = self.components.getIndex(MyTrips.components(start)) {
            self.year = year
            self.month = month
            self.day = day
            
        }
    }
    
    convenience init(_ components: Components) {
        self.init(components, start: .distantPast, end: .distantFuture)
    }
    
    private func isOver(_ trip: Trip) -> Bool {
        if trip.startDate <= self.end {
            return false
            
        }
        
        // Check to make sure it isn't the same day as the end
        if MyTrips.components(self.end) == MyTrips.components(trip.startDate) {
            return false
        }
        
        return true
    }
    
    private func get(_ index: (Int, Int, Int, Int)) -> (Year, Month, Day, Trip) {
        
        let year = self.components.years[index.0]
        let month = year.months[index.1]
        let day = month.days[index.2]
        let trip = day.trips[index.3]
        return (year, month, day, trip)
    }
    
    
    private func get() -> (Year, Month, Day, Trip) {
        get((self.year!, self.month!, self.day!, self.trip!))
    }
    
    private func nextIndex() -> (Int, Int, Int, Int)? {
        // Components is empty within range
        if self.year == nil {
            return nil
        }
        
        // Begin iterating
        if self.trip == nil {
            return (self.year!, self.month!, self.day!, 0)
        }
        
        let (year, month, day, _) = get()
        if self.trip! + 1 < day.trips.count {
            
            return (self.year!, self.month!, self.day!, self.trip! + 1)
        }
        if self.day! + 1 < month.days.count {
            return (self.year!, self.month!, self.day! + 1, 0)
        }
        if self.month! + 1 < year.months.count {
            return (self.year!, self.month! + 1, 0, 0)
        }
        if self.year! + 1 < self.components.years.count {
            return (self.year! + 1, 0, 0, 0)
        }
        return nil
    }
    
    func next() -> Trip? {
        if let index = nextIndex() {
            self.year = index.0
            self.month = index.1
            self.day = index.2
            self.trip = index.3
            let (_, _, _, trip) = get(index)
            return isOver(trip) ? nil : trip
        }
        return nil
    }
    
    
}
