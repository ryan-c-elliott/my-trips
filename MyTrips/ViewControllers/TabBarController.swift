//
//  TabBarController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/1/21.
//

import UIKit

class TabBarController: UITabBarController {

    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData(components: Components())
    
    let dateFormatter: DateFormatter = DateFormatter()
    let timeFormatter: DateFormatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //write(url: getURL(filename: "data")!, data: ResponseData(components: Components()))
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        self.timeFormatter.locale = Locale(identifier: "en_US")
        // Do any additional setup after loading the view.
    }
    
    func reloadData() {
        let history = self.children[1] as! HistoryViewController
        if history.isViewLoaded {
            //history.calendarView.reloadData()
            history.tableView.reloadData()
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
