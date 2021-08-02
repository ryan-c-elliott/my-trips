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

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    


    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var trips: [Trip] = []
    var components: Components = Components() // Helps tableView react to calendar selection
    //var sectionStarts: [Int] = [] // Helps organize the tableView
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    let dateFormatter: DateFormatter = DateFormatter()
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trips = (self.parent as! TabBarController).data.trips
        
        for trip in trips {
            components.add(trip)
        }
        
        /*
        // Set up sectionStarts
        var last: DateComponents = self.components(.distantPast)
        for i in 0..<self.trips.count {
            let date = self.trips[i].startDate
            let curr = self.components(date)
            if curr != last {
                self.sectionStarts.append(i)
                self.dateStarts.append(curr)
                last = curr
            }
        }
 */
        
        // DateFormatter
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        
        
        /*
        // Print stuff
        for i in sectionStarts {
            print(i, terminator: " ")
        }
        print()
        print()
        print(data)
        */
        
        
        // FSCalendar
        self.calendarView.calendarHeaderView.scrollDirection = .vertical
        self.calendarView.register(CalendarCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        

        
        
        
        
        
        // Header Buttons
        self.calendarView.bringSubviewToFront(self.todayButton)
        
        // TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    /* * Actions * */
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        self.calendarView.select(self.calendarView.today)
    }
    
    /* * Helpers * */
    
    func components(_ date: Date) -> DateComponents {
        self.calendar.dateComponents(self.dateComponents, from: date)
    }
    
    /* * FSCalendar * */
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        calendar.today!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let (_, section) = components.rowAndSectionFor(date)
        let indexPath = IndexPath(row: 0, section: section)
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    /* * UITableView * */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //sectionStarts.count
        self.components.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        let next = section == numberOfSections(in: tableView)-1 ? self.trips.count : sectionStarts[section+1]
        return next - sectionStarts[section]
        */
        /*
        if let trip = self.components.get(section: section) {
            return trip.count
        }
        return 0
 */
        self.components.get(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        
        //let trip = self.trips[indexPath.row + sectionStarts[indexPath.section]]
        let trip = self.components.get(row: indexPath.row, section: indexPath.section)
        
        cell.textLabel?.text = trip.startDate.description
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //self.dateFormatter.string(from: self.trips[sectionStarts[section]].startDate)
        self.dateFormatter.string(from: self.components.get(row: 0, section: section).startDate)
    }
    


}
