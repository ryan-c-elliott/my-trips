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
    
    


    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(startDate: Date(), trips: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Gets rid of the faded months on the left and right of the header
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0
        
    }
    
    /* * UITableViewDataSource * */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    


}
