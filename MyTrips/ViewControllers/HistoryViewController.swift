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
    @IBOutlet weak var insertButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    var components: Components = Components() // Helps tableView react to calendar selection
    var dateFormatter: DateFormatter = DateFormatter()
    var timeFormatter: DateFormatter = DateFormatter()
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.parent as! TabBarController
        
        self.components = parent.data.components
        self.dateFormatter = parent.dateFormatter
        self.timeFormatter = parent.timeFormatter
        
        // DateFormatters
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        self.timeFormatter.locale = Locale(identifier: "en_US")

        
        // FSCalendar
        self.calendarView.calendarHeaderView.scrollDirection = .vertical
        self.calendarView.register(CalendarCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        

        
        
        
        
        
        // Header Buttons
        self.calendarView.bringSubviewToFront(self.todayButton)
        self.calendarView.bringSubviewToFront(self.insertButton)
        
        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
    }
    
    /* * Actions * */
    
    @IBAction func insertButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "Insert")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        self.calendarView.select(self.calendarView.today)
        self.scrollToDate(self.calendarView.today!)
    }
    
    /* * Helpers * */
    
    func components(_ date: Date) -> DateComponents {
        self.calendar.dateComponents(self.dateComponents, from: date)
    }
    
    func scrollToDate(_ date: Date) {
        if self.components.sectionCount == 0 {
            return
        }
        let (_, section) = self.components.rowAndSectionFor(date)
        let indexPath = IndexPath(row: 0, section: min(section, self.components.sectionCount-1))
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    /* * FSCalendar * */
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        calendar.today!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.scrollToDate(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let (_, section) = self.components.rowAndSectionFor(date)
        let trips = self.components.get(section: section)
        if self.components(trips[0].startDate) == self.components(date) {
            return trips.count
        }
        return 0
    }
    
    /* * UITableView * */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.components.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.components.get(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! TableViewCell
        
        let trip = self.components.get(row: indexPath.row, section: indexPath.section)
        let startTime = self.timeFormatter.string(from: trip.startDate)
        let endTime = self.timeFormatter.string(from: trip.endDate)
        
        cell.textLabel?.text = "\(startTime) - \(endTime)"
        cell.mileLabel.text = "\(trip.distance) mi"
                
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        self.dateFormatter.string(from: self.components.get(row: 0, section: section).startDate)
    }
    


}
