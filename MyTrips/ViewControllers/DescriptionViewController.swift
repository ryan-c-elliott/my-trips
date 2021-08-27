//
//  DescriptionViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/27/21.
//

import UIKit
import MapKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var mileLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var delegate: HistoryViewController = HistoryViewController()
    var dateFormatter: DateFormatter = DateFormatter()
    var timeFormatter: DateFormatter = DateFormatter()
    var trip: Trip = Trip()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Description Text Box
        self.descriptionTextBox.text = self.trip.description
        
        // Date Label
        self.dateLabel.text = self.dateFormatter.string(from: self.trip.getStartDate())
        
        // Time Labels
        self.startTimeLabel.text = self.timeFormatter.string(from: self.trip.getStartDate())
        self.endTimeLabel.text = self.timeFormatter.string(from: self.trip.getEndDate())
        
        // Mile Label
        self.mileLabel.text = "\((self.trip.distance * 10).rounded() / 10) mi"
        
        // Map
        self.map.isZoomEnabled = false
        self.map.isScrollEnabled = false
        self.map.isPitchEnabled = false
        self.map.isRotateEnabled = false
        self.map.delegate = self
        
        // Add named points on map
        let startLoc = trip.start.toCLLocation();
        let endLoc = trip.end.toCLLocation();
        self.addLocation(startLoc)
        self.addLocation(endLoc)
        
        route(start: startLoc, end: endLoc, onSuccess: { route in
            
            //show on map
            self.map.addOverlay(route.polyline)
            
            //set the map area to show the route
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
        }, onFailure: {})
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.trip.setDescription(self.descriptionTextBox.text)
        self.delegate.reloadData()
        tripsWrite(data: self.delegate.parentController.data)
    }
    
    /* * Actions * */
    
    @IBAction func doneWithKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /* * Helpers * */
    
    func addLocation(_ location: CLLocation) {
        
        // Look up the location and pass it to the completion handler
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            let point = MKPointAnnotation()
            point.coordinate = location.coordinate
            point.title = error == nil ? placemarks?[0].name : "Unknown Location"
            self.map.addAnnotation(point)
        })
    }
    
}

extension DescriptionViewController: MKMapViewDelegate {
    //this delegate function is for displaying the route overlay and styling it
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
}
