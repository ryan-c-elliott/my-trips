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
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var sectionStarts: [Int] = [] // Helps organize the tableView
    var calendar: Calendar = Calendar(identifier: .gregorian)
    
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    let dateFormatter: DateFormatter = DateFormatter()
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.parent as! TabBarController
        let trips = parent.data.trips
        
        // Set up sectionStarts
        var last: DateComponents = calendar.dateComponents(dateComponents, from: Date.distantPast)
        for i in 0..<trips.count {
            let curr = calendar.dateComponents(dateComponents, from: trips[i].startDate)
            if curr != last {
                sectionStarts.append(i)
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
        let appearance = self.calendarView.appearance
        appearance.headerMinimumDissolvedAlpha = 0
        let topColor: UIColor = UIColor(red: 0, green: 100/255, blue: 0, alpha: 1)
        appearance.headerTitleColor = topColor
        appearance.weekdayTextColor = topColor
        appearance.todayColor = self.todayButton.titleColor(for: .normal)
        appearance.selectionColor = .systemRed
        self.calendarView.calendarHeaderView.scrollDirection = .vertical
        self.calendarView.headerHeight = 25
        
        
        
        
        
        // Header Buttons
        /*
        print(self.calendarView.headerHeight)
        
        print(self.calendarView.frame.width)
        
        let buttonWidth: CGFloat = 50
        let xpos = self.view.frame.width - buttonWidth - 12.5
        let title = "Today"
        let todayButton = UIButton(frame: CGRect(
                                    x: xpos,
                                    y: 0,
                                    width: buttonWidth,
                                    height: 25
        ))
        todayButton.setTitle(title, for: .normal)
        todayButton.setTitleColor(appearance.headerTitleColor, for: .normal)
        todayButton.titleLabel?.font = appearance.headerTitleFont
        self.calendarView.calendarHeaderView.addSubview(todayButton)
 */
        self.calendarView.bringSubviewToFront(self.todayButton)
        
        
        
        // TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        
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
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        
        let trip = self.data.trips[indexPath.row + sectionStarts[indexPath.section]]
        
        
        cell.textLabel?.text = trip.startDate.description
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.dateFormatter.string(from: self.data.trips[sectionStarts[section]].startDate)
    }
    


}
