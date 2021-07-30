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

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    


    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(trips: [])
    
    // Helps organize the tableView
    var sectionStarts: [Int] = []
    var calendar: Calendar = Calendar(identifier: .gregorian)
    
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up sectionStarts
        var last: DateComponents = calendar.dateComponents(dateComponents, from: Date.distantPast)
        for i in 0..<data.trips.count {
            let curr = calendar.dateComponents(dateComponents, from: data.trips[i].startDate)
            if curr != last {
                sectionStarts.append(i)
                last = curr
            }
        }
        
        // FSCalendar
        // Gets rid of the faded months on the left and right of the header
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0
        
    }
    
    /* * UITableView * */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionStarts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let next = section == sectionStarts.count-1 ? self.data.trips.count : sectionStarts[section+1]
        return next - sectionStarts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    


}
