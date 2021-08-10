//
//  TripViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 7/24/21.
//

import UIKit
import MapKit

class TripViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var tripButton: TripButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var manager: CLLocationManager = CLLocationManager()
    var start: CLLocation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let parent = self.parent as! TabBarController
        
        
        
        // Manager
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        //self.manager.desiredAccuracy = 25
        
        // Map
        self.map.isZoomEnabled = false
        self.map.isScrollEnabled = false
        self.map.isPitchEnabled = false
        self.map.isRotateEnabled = false
        
        
        // Arrange subviews
        self.view.bringSubviewToFront(self.tripButton)
        self.view.bringSubviewToFront(self.activityIndicatorView)
            
        // ActivityIndicator
        self.activityIndicator.stopAnimating()
        self.activityIndicatorView.alpha = 0
        
        // Start
        if let start = parent.data.start {

            self.start = CLLocation(
                coordinate: CLLocationCoordinate2D(
                    latitude: start.latitude,
                    longitude: start.longitude
                
                ),
                altitude: 0,
                horizontalAccuracy: self.manager.desiredAccuracy,
                verticalAccuracy: self.manager.desiredAccuracy,
                timestamp: start.date
            )
        } else {
            self.start = nil
        }
        
        // Set Region
        self.setRegion()
        
        // TripButton
        let tripStarted = self.start != nil
        if tripStarted != self.tripButton.trip {
            self.tripButton.toggle()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    // Returns true if the app has access to location services and false otherwise
    func enabled(_ manager: CLLocationManager) -> Bool {
        switch manager.authorizationStatus {
            case .authorizedAlways,
                 .authorizedWhenInUse:
                return true
            default:
                return false
        }
    }
    
    func toggleActivityIndicator() {
        if self.activityIndicator.isAnimating { // Stop animating
            self.activityIndicator.stopAnimating()
            self.tripButton.isUserInteractionEnabled = true
            self.activityIndicatorView.alpha = 0
        } else {                                // Start animating
            self.activityIndicator.startAnimating()
            self.tripButton.isUserInteractionEnabled = false
            self.activityIndicatorView.alpha = 0.9
        }
    }
    
    
    /* * CLLocationManagerDelegate * */
    
    // When new location is retrieved
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!
        let parent = self.parent as! TabBarController
        
        if let start = self.start {   // Trip was just ended
            
            let endCoords = loc.coordinate
            self.setRegion(end: endCoords)
            
            // Convert to MKPlacemark
            let request = MKDirections.Request()
            let source = MKPlacemark(coordinate: start.coordinate)
            let dest = MKPlacemark(coordinate: endCoords)
            request.source = MKMapItem(placemark: source)
            request.destination = MKMapItem(placemark: dest)
            request.transportType = MKDirectionsTransportType.automobile
            request.requestsAlternateRoutes = false
            
            // Find directions
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if let response = response, let route = response.routes.first {
                    
                    // Add trip
                    parent.data.tripData.add(Trip(
                        startDate: start.timestamp,
                        endDate: loc.timestamp,
                        route: route
                    ))
                    
                    // Change start
                    self.start = nil
                    parent.data.start = nil
                    tripsWrite(data: parent.data)
                    
                    // Reload
                    parent.reloadData()
                    
                    // Show route on map
                    self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                } else {
                    print("couldn't calculate route")
                }
            }
            
            
        } else { // Trip was just started
        
        
            // Change start
            self.start = loc
            parent.data.start = Location(location: loc)
            write(url: getURL(filename: "data")!, data: parent.data)
            
            // Show location
            self.setRegion()
        }
        self.toggleActivityIndicator()
        
    }

    /* * Location Manager * */

    // When the authorization status of the app is changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.tripButton.locationIsOn = self.enabled(manager)
    }
    
    // When manager fails
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
    }
    
    
    func requestLocationServices() {
        // present an alert indicating location authorization required
        // and offer to take the user to Settings for the app via
        // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error!", message: "Location services needs to be enabled to start a trip.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                
                }
            ))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")

                self.dismiss(animated: true, completion: nil)
                }
            ))
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    @IBAction func tripButtonTapped(_ sender: TripButton) {
        
        
        if !sender.locationIsOn {

            self.requestLocationServices()
            return
        }

        self.toggleActivityIndicator()
        sender.toggle()
        self.manager.requestLocation()
        
        // Most work will be done in the locationManagerDidUpdateLocations function
        
        
    }
    
    
    
    func setRegion() {
        guard let start = self.start else {
            return
        }
        self.map.setRegion(
            MKCoordinateRegion(
                center: start.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ),
            animated: true
        )
        
    }
    
    func setRegion(end: CLLocationCoordinate2D) {
        guard let start = self.start else {
            return
        }
        let slat = start.coordinate.latitude
        let slong = start.coordinate.longitude
        let lat = mid(slat, end.latitude)
        let long = mid(slong,  end.longitude)
        self.map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                latitudinalMeters: abs(slat - end.latitude) + 500,
                longitudinalMeters: abs(slong - end.longitude) + 500
            ),
            animated: true
        )
    }
    
}
