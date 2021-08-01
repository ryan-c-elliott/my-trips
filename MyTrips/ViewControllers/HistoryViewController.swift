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
    var sectionStarts: [Int] = [] // Helps organize the tableView
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    let dateFormatter: DateFormatter = DateFormatter()
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trips = (self.parent as! TabBarController).data.trips
        
        // Set up sectionStarts
        var last: DateComponents = self.calendar.dateComponents(self.dateComponents, from: Date.distantPast)
        for i in 0..<self.trips.count {
            let date = self.trips[i].startDate
            let curr = self.calendar.dateComponents(self.dateComponents, from: date)
            if curr != last {
                self.sectionStarts.append(i)
                last = curr
            }
        }
        
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

        
        
        
        
        
        // Header Buttons
        self.calendarView.bringSubviewToFront(self.todayButton)
        
        // TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        self.calendarView.select(self.calendarView.today)
    }
    
    
    /* * FSCalendar * */
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    /* * UITableView * */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionStarts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let next = section == sectionStarts.count-1 ? self.trips.count : sectionStarts[section+1]
        return next - sectionStarts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        
        let trip = self.trips[indexPath.row + sectionStarts[indexPath.section]]
        
        
        cell.textLabel?.text = trip.startDate.description
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.dateFormatter.string(from: self.trips[sectionStarts[section]].startDate)
    }
    


}
