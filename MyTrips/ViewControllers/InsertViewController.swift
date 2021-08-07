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

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var insertButton: UIButton!
    
    var startLoc: CLLocationCoordinate2D? = nil
    var endLoc: CLLocationCoordinate2D? = nil
    
    var delegate: TabBarController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DatePicker
        self.datePicker.maximumDate = Date()
        
        // LocLabel
        self.locLabel.text = ""
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func locPicker(_ sender: UIButton) {
        self.locLabel.text = ""
        let lp = LocationPickerViewController()
        lp.completion = { location in
            if sender == self.startButton {
                self.startLabel.text = location?.name
                self.startLoc = location?.coordinate
            } else {
                self.endLabel.text = location?.name
                self.endLoc = location?.coordinate
            }
        }
        navigationController!.pushViewController(lp, animated: true)
        
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
        
        // Find directions
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let response = response, let route = response.routes.first {
    
                let data = self.delegate!.data
                data.components.insert(Trip(
                    startDate: startDate,
                    endDate: endDate,
                    route: route
                ))
                tripsWrite(data: data)
                self.delegate!.reloadData()
                self.dismiss(animated: true, completion: nil)
 
            } else {
                self.locLabel.text = "Couldn't calculate route"
            }
        }
        
        
        
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



