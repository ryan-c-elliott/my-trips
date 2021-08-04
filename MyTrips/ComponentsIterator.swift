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
    private let start: DateComponents
    private let end: DateComponents
    private var year: Int? = nil
    private var month: Int? = nil
    private var day: Int? = nil
    private var trip: Int? = nil
    
    init(_ components: Components, start: Date, end: Date) {
        self.components = components
        self.start = MyTrips.components(start)
        self.end = MyTrips.components(end)
        if let (year, month, day) = self.components.getIndex(self.start) {
            self.year = year
            self.month = month
            self.day = day
            
        }
    }
    
    private func getYear() -> Year {
        self.components.years[self.year!]
    }
    
    private func getMonth() -> Month {
        getYear().months[self.month!]
    }
    
    private func getDay() -> Day {
        getMonth().days[self.day!]
    }
    
    private func getTrip() -> Trip {
        getDay().trips[self.trip!]
    }
    
    private func nextIndex() -> (Int, Int, Int, Int)? {
        if self.trip == nil {
            return (self.year!, self.month!, self.day!, 0)
        }
        let day: Day = getDay()
        if self.trip! + 1 < day.trips.count {
            return (self.year!, self.month!, self.day!, self.trip! + 1)
        }
        let month: Month = getMonth()
        if self.day! + 1 < month.days.count {
            return (self.year!, self.month!, self.day! + 1, 0)
        }
        let year: Year = getYear()
        if self.month! + 1 < year.months.count {
            return (self.year!, self.month! + 1, 0, 0)
        }
        if self.year! + 1 < self.components.years.count {
            return (self.year! + 1, 0, 0, 0)
        }
        return nil
    }
    
    func next() -> Trip? {
        if let (year, month, day, trip) = nextIndex() {
            self.year = year
            self.month = month
            self.day = day
            self.trip = trip
            return getTrip()
        }
        return nil
    }
    
    
}
