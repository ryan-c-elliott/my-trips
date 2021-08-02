//
//  TabBarController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/1/21.
//

import UIKit

class TabBarController: UITabBarController {

    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(components: Components())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func reloadData() {
        let history = self.children[1] as! HistoryViewController
        history.calendarView.reloadData()
        history.tableView.reloadData()
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
