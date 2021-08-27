//
//  InsertViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/4/21.
//

import UIKit
import MapKit
import LocationPicker

class InsertViewController: UIViewController {

    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var insertButton: UIButton!
    
    var startLoc: CLLocationCoordinate2D?
    var endLoc: CLLocationCoordinate2D?
    
    let noLoc = "No Location Selected"
    
    var delegate: TabBarController = TabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextBox
        self.descriptionTextBox.autocorrectionType = .no
        self.descriptionTextBox.autocapitalizationType = .words
        self.descriptionTextBox.returnKeyType = .done
        
        // DatePicker
        self.datePicker.maximumDate = Date()
        
        // LocLabel
        self.locLabel.text = ""
        
        // Start and End Labels
        self.startLabel.text = self.noLoc
        self.endLabel.text = self.noLoc
        
        
        // Do any additional setup after loading the view.
    }
    
    /* * Alerts * */
    
    
    func failedToFindLocation() {
        
        let alert = UIAlertController(title: "Error!", message: "Couldn't find location.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        
        ))

        self.present(alert, animated: true, completion: nil)

    }
    
    
    /* * Actions * */
    
    @IBAction func locPicker(_ sender: UIButton) {
        self.locLabel.text = ""
        let lp = LocationPickerViewController()
        lp.completion = { location in
            guard let location = location else {
                
                self.failedToFindLocation()
                
                return
            }
            
            
            if sender == self.startButton {
                
                self.startLabel.text = location.name ?? location.address
                self.startLoc = location.coordinate
            } else {
                self.endLabel.text = location.name ?? location.address
                self.endLoc = location.coordinate
            }
        }
        self.navigationController!.pushViewController(lp, animated: true)
        
    }
    
    @IBAction func doneWithKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func insertButtonTapped(_ sender: UIButton) {
        if startLoc == nil || endLoc == nil {
            
            self.locLabel.text = "Pick a start and end location"
            
            return
        }
        
        // Figure out dates
        let dateComponents = components(self.datePicker.date)
        let startTimeComponents = MyTrips.components(self.startTimePicker.date, components: [.hour, .minute])
        let endTimeComponents = MyTrips.components(self.endTimePicker.date, components: [.hour, .minute])
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        
        // If app gets popular, add something to allow change in calendar and timeZone
        let startComponents = DateComponents(
            calendar: calendar,
            timeZone: nil, era: nil,
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: startTimeComponents.hour,
            minute: startTimeComponents.minute,
            second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        )
        
        var endComponents = startComponents
        endComponents.hour = endTimeComponents.hour
        endComponents.minute = endTimeComponents.minute
        
        // If start time is > end time then the trip lasted through midnight
        if startTimeComponents.hour! > endTimeComponents.hour! ||
           (startTimeComponents.hour! == endTimeComponents.hour! &&
           startTimeComponents.minute! > endTimeComponents.minute!) {
            endComponents.day! += 1
        }
        
        let startDate = calendar.date(from: startComponents)!
        let endDate = calendar.date(from: endComponents)!
        
        // Convert to MKPlacemark
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: startLoc!)
        let dest = MKPlacemark(coordinate: endLoc!)
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: dest)
        request.transportType = MKDirectionsTransportType.automobile
        request.requestsAlternateRoutes = false
        
        // Get description
        let description = self.descriptionTextBox.text
        
        // Find directions
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let response = response, let route = response.routes.first {
    
                // Add to data structure
                let data = self.delegate.data
                data.tripData.insert(Trip(
                    description: description,
                    startDate: startDate,
                    endDate: endDate,
                    route: route
                ))
                
                // Write
                tripsWrite(data: data)
                
                // Reload
                self.delegate.reloadData()
                
                // Dismiss
                self.dismiss(animated: true, completion: nil)
 
            } else {
                self.locLabel.text = "Couldn't calculate route"
            }
        }
        
        
        
        
    }
    
}



