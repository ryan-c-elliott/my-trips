//
//  InsertViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/4/21.
//

import UIKit

class InsertViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startSearchBar: UISearchBar!
    @IBOutlet weak var startTableView: UITableView!
    @IBOutlet weak var endSearchBar: UISearchBar!
    @IBOutlet weak var endTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
