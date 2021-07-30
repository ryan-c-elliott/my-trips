//
//  HistoryViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import UIKit
import JTAppleCalendar
import KDCalendar
import FSCalendar

class HistoryViewController: UIViewController{


    @IBOutlet weak var calendar: FSCalendar!
    
    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(startDate: Date(), trips: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        
    }
    
    


}
