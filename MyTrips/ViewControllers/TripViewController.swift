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
    
    var manager: CLLocationManager = CLLocationManager()
    var start: CLLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Manager
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        // Maybe set desiredAccuracy later?
        // Remember you can use manager.location to get the most recently retrieved location
        
        // Map
        self.map.isZoomEnabled = false
        self.map.isScrollEnabled = false
        self.map.isPitchEnabled = false
        self.map.isRotateEnabled = false
        self.setRegion()
        
        // Trip Button
        self.view.bringSubviewToFront(self.tripButton)
            
        
        
        
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
    
    
    /* * CLLocationManagerDelegate * */
    
    // When new location is retrieved
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let loc = manager.location!
        if self.tripButton.trip {   // Trip was just started
            self.start = loc
            self.setRegion()
        } else {    // Trip was just ended
            
            let coords1 = self.start.coordinate
            let coords2 = loc.coordinate
            self.setRegion(start: coords1, end: coords2)
            
            // Find route
            let request = MKDirections.Request()
            let source = MKPlacemark(coordinate: coords1)
            let dest = MKPlacemark(coordinate: coords2)
            request.source = MKMapItem(placemark: source)
            request.destination = MKMapItem(placemark: dest)
            request.transportType = MKDirectionsTransportType.automobile
            request.requestsAlternateRoutes = false
            let directions = MKDirections(request: request)
            directions.calculate { (response, error) in
                if let response = response, let route = response.routes.first {
                    (self.parent!.children[1] as! HistoryViewController).data.trips.append(Trip(
                        startDate: self.start.timestamp,
                        endDate: loc.timestamp,
                        route: route
                    ))
                    self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                } else {
                    print("couldn't calculate route")
                }
            }
        }
        
    }

    /* * Location Manager * */

    // When the authorization status of the app is changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.tripButton.location = enabled(manager)
    }
    
    // When manager fails
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        if !sender.location {

            requestLocationServices()
            return
        }

        sender.toggle()
        self.manager.requestLocation()
        
        // Most work will be done in the locationManagerDidUpdateLocations function
        
        
    }
    
    func setRegion() {
        self.map.setRegion(
            MKCoordinateRegion(
                center: start.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ),
            animated: true
        )
        
    }
    
    func setRegion(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let lat = mid(start.latitude, end.latitude)
        let long = mid(start.longitude,  end.longitude)
        self.map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                latitudinalMeters: abs(start.latitude - end.latitude) + 500,
                longitudinalMeters: abs(start.longitude - end.longitude) + 500
            ),
            animated: true
        )
    }
    
}
