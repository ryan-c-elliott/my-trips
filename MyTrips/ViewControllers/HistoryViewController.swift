//
//  HistoryViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendarView: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    

    var parentController: TabBarController = TabBarController()
    var tripData: TripData = TripData()
    var dateFormatter: DateFormatter = DateFormatter()
    var timeFormatter: DateFormatter = DateFormatter()
    
    let calendar: Calendar = Calendar(identifier: .gregorian)
    let dateComponents: Set<Calendar.Component> = [.day, .month, .year]
    let cellReuseIdentifier = "cell"
    
    func reloadData() {
        self.tableView.reloadData()
        
        // CalendarView
        self.calendarView.maximumDate = self.calendar.date(byAdding: .day, value: 1, to: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentController = self.parent as! TabBarController
        
        self.tripData = parentController.data.tripData
        self.dateFormatter = parentController.dateFormatter
        self.timeFormatter = parentController.timeFormatter
        
        // TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        // Reload
        self.reloadData()
        
    }
    
    /* * Actions * */
    
    @IBAction func insertButtonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Insert") as! InsertViewController
        vc.delegate = self.parent as? TabBarController
        vc.title = "Create Trip"
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        // get "today" date
        let today = Date()
        
        // get selected date
        let pickerDate = self.calendarView.date
        
        // are the dates the same day?
        let todayIsSelected = Calendar.current.isDate(today, inSameDayAs:pickerDate)

        if todayIsSelected {
            // picker has today selected, but may have scrolled months...

            // should never fail, but this unwraps the optional
            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
                return
            }

            // animate to "tomorrow"
            self.calendarView.setDate(nextDay, animated: true)

            // async call to animate to "today" - delay for 0.1 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.calendarView.setDate(today, animated: true)
            })
        } else {
            // picker has a different date selected
            //  so just animate to "today"
            self.calendarView.setDate(today, animated: true)
        }
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        self.scrollToDate(self.calendarView.date)
    }
    
    
    /* * Helpers * */
    
    func scrollToDate(_ date: Date) {
        let n = self.tripData.days.count
        if n == 0 {
            return
        }
        let (_, section) = self.tripData.rowAndSectionFor(date)
        let indexPath = IndexPath(row: 0, section: min(section, n-1))
        
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    /* * UITableView * */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tripData.days.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tripData.get(section: section)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as! TableViewCell
        
        let trip = self.tripData.get(row: indexPath.row, section: indexPath.section)!
        
        cell.textLabel?.text = { () -> String in
            if let description = trip.description {
                return description
            } else {
                let startTime = self.timeFormatter.string(from: trip.getStartDate())
                let endTime = self.timeFormatter.string(from: trip.getEndDate())
                return "\(startTime) - \(endTime)"
            }
        }()
        
        
        
        cell.mileLabel.text = "\((trip.distance * 10).rounded() / 10) mi"
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        self.dateFormatter.string(from: self.tripData.get(row: 0, section: section)!.getStartDate())
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteTrip(tableView, forRowAt: indexPath)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    /* * Alerts * */
    
    func deleteTrip(_ tableView: UITableView, forRowAt indexPath: IndexPath){
        // present an alert asking the user if they really want to delete the trip
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to remove this trip?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) in
                print("")
                
                // Remove from data structure
                let _ = self.tripData.remove(row: indexPath.row, section: indexPath.section)
                
                // Write
                tripsWrite(data: self.parentController.data)
                
                // Reload
                self.parentController.reloadData()
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) in
                print("")

                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}
