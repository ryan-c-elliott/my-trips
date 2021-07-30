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

class HistoryViewController: UIViewController /*, CalendarViewDataSource, CalendarViewDelegate */{


    @IBOutlet weak var calendar: FSCalendar!
    
    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(startDate: Date(), trips: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        /* KDCalendar
        self.calendar.setDisplayDate(today, animated: false)
        self.calendar.style.firstWeekday = .sunday
        self.calendar.direction = .vertical
      */
    }
    
    /* KDCalendar
    /* * CalendarView DataSource and Delegate * */
    
    func startDate() -> Date {
        //data.startDate
        var comps = DateComponents()
        comps.month = -3
        return self.calendar.calendar.date(byAdding: comps, to: Date())!
    }
    
    func endDate() -> Date {
        Date()
    }
    
    func headerString(_ date: Date) -> String? {
        nil
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
            
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        
        switch (date.compare(endDate()), date.compare(startDate())) {
            case (.orderedDescending, _), (_, .orderedAscending):
                return false
            default:
                return true
        }
 

    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
            
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
            
    }
    */


}
