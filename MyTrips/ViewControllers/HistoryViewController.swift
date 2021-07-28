//
//  HistoryViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import UIKit
import KDCalendar

class HistoryViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {


    @IBOutlet weak var calendar: CalendarView!
    
    var trips: [Trip] = [] // change to load a json
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    
    /* * CalendarView DataSource and Delegate * */
    
    func startDate() -> Date {
        <#code#>
    }
    
    func endDate() -> Date {
        <#code#>
    }
    
    func headerString(_ date: Date) -> String? {
        <#code#>
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        <#code#>
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        <#code#>
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        <#code#>
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        <#code#>
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        <#code#>
    }
    


}
