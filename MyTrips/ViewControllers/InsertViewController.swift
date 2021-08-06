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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DatePicker
        self.datePicker.maximumDate = Date()
        
        // LocLabel
        self.locLabel.text = ""
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func locPicker(_ sender: UIButton) {
        let lp = LocationPickerViewController()
        lp.completion = { location in
            if sender == self.startButton {
                self.startLabel.text = location?.address
            } else {
                self.endLabel.text = location?.address
            }
        }
        navigationController!.pushViewController(lp, animated: true)
        
    }
    
    
    @IBAction func insertButtonTapped(_ sender: UIButton) {
        
        
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



