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
    //var coords: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Manager
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestLocation()
        // Maybe set desiredAccuracy later?
        // Remember you can use manager.location to get the most recently retrieved location
        
        // Map
        self.map.isZoomEnabled = false
        self.map.isScrollEnabled = false
        self.map.isPitchEnabled = false
        self.map.isRotateEnabled = false
        
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
    
    // Sets the map to a new location
    func setMap(_ manager: CLLocationManager) {
        self.map.centerCoordinate = manager.location!.coordinate
    }
    
    /* * CLLocationManagerDelegate * */
    
    // When new location is retrieved
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        setMap(manager)
        
        
        
        
        
        
    }

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

    @IBAction func tripButtonTapped(_ sender: TripButton) {
        if !sender.location {

            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error!", message: "Location services needs to be enabled to start a trip.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                    print("")
                    UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                    
                    }
                ))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                    print("")

                    self.dismiss(animated: true, completion: nil)
                    }
                ))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            return
        }
        if sender.trip {    // Stop the trip
            
        } else {    // Start the trip
            
        }
        self.manager.requestLocation()
        sender.toggle()
        
        
    }
    
}
