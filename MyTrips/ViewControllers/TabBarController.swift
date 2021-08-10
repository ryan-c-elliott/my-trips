//
//  TabBarController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/1/21.
//

import UIKit

class TabBarController: UITabBarController {

    var data: ResponseData = loadJson(url: getURL(filename: "data")!) ?? ResponseData()
    
    let dateFormatter: DateFormatter = DateFormatter()
    let timeFormatter: DateFormatter = DateFormatter()
    
    func reloadData() {
        
        let history = self.children[1] as! HistoryViewController
        if history.isViewLoaded {
            history.reloadData()
        }
        
        let export = self.children[2] as! ExportViewController
        if export.isViewLoaded {
            export.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //write(url: getURL(filename: "data")!, data: ResponseData())
        
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.timeFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
        self.timeFormatter.amSymbol = "am"
        self.timeFormatter.pmSymbol = "pm"
        self.timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        // Do any additional setup after loading the view.
    }
}
