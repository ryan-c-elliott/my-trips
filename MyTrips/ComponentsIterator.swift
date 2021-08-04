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
    
    func next() -> Trip? {
        nil
    }
    
    
}
