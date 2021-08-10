//
//  TripDataIterator.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/9/21.
//

import Foundation

protocol Iterable {
    func makeIterator(start: Date, end: Date) -> TripDataIterator
}

protocol TripIterator {
    func next() -> Trip?
}

class TripDataIterator: TripIterator {
    
    private let tripData: TripData
    private let start: Date
    private let end: Date
    private var day: Int?
    private var trip: Int?
    
    init(_ data: TripData, start: Date, end: Date) {
        self.tripData = data
        self.start = start
        self.end = end
        if let day = self.tripData.getIndex(start) {
            self.day = day
        }
    }
    
    convenience init(_ data: TripData) {
        self.init(data, start: .distantPast, end: .distantFuture)
    }
    
    private func isOver(_ trip: Trip) -> Bool {
        if trip.getStartDate() <= self.end {
            return false
            
        }
        
        return true
    }
    
    private func get(_ index: (Int, Int)) -> (Day, Trip) {
        
        let day = self.tripData.days[index.0]
        let trip = day.trips[index.1]
        return (day, trip)
    }
    
    
    private func get() -> (Day, Trip) {
        get((self.day!, self.trip!))
    }
    
    private func nextIndex() -> (Int, Int)? {
        // Components is empty within range
        if self.day == nil {
            return nil
        }
        
        // Begin iterating
        if self.trip == nil {
            return (self.day!, 0)
        }
        
        let (day, _) = get()
        
        // If there is another trip in the current day
        if self.trip! + 1 < day.trips.count {
            
            return (self.day!, self.trip! + 1)
        }
        
        // If there is another day in days
        if self.day! + 1 < self.tripData.days.count {
            return (self.day! + 1, 0)
        }

        return nil
    }
    
    func next() -> Trip? {
        if let index = nextIndex() {
            self.day = index.0
            self.trip = index.1
            let (_, trip) = get(index)
            return isOver(trip) ? nil : trip
        }
        return nil
    }
    
    
}
