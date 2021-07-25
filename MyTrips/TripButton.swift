//
//  TripButton.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import UIKit

class TripButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var trip: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bringSubviewToFront(self)
        self.layer.cornerRadius = 12.5
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func toggle() {
        if trip {   // Stop the trip
            self.titleLabel?.text = "Start New Trip"
        } else {    // Start the trip
            self.titleLabel?.text = "End Trip"
        }
        trip = !trip
    }
    
}
