//
//  InsertViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/4/21.
//

import UIKit
import MapKit

class InsertViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startSearchBar: UISearchBar!
    @IBOutlet weak var startTableView: UITableView!
    @IBOutlet weak var endSearchBar: UISearchBar!
    @IBOutlet weak var endTableView: UITableView!
    @IBOutlet weak var insertButton: UIButton!
    
    @IBOutlet weak var startTableHeight: NSLayoutConstraint!
    @IBOutlet weak var endTableHeight: NSLayoutConstraint!
    
    var startSearchCompleter = MKLocalSearchCompleter()
    var endSearchCompleter = MKLocalSearchCompleter()
    var startSearchResults = [MKLocalSearchCompletion]()
    var endSearchResults = [MKLocalSearchCompletion]()
    
    //var tableHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableHeight = self.view.frame.height - 325
        
        // TableView
        self.startTableView.delegate = self
        self.startTableView.dataSource = self
        self.endTableView.delegate = self
        self.endTableView.dataSource = self
        
        // Search
        self.startSearchCompleter.delegate = self
        self.endSearchCompleter.delegate = self
        self.startSearchBar.delegate = self
        self.endSearchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    

    func tableHeight() -> CGFloat {
        self.view.frame.height - 312.5
    }
    /*
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if self.startTableHeight.constant != 0 {
            self.startTableHeight.constant = tableHeight()
            
        }
        if self.endTableHeight.constant != 0 {
            self.endTableHeight.constant = tableHeight()
        }
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InsertViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView == self.startTableView ? self.startSearchResults.count : self.endSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = tableView == self.startTableView ? self.startSearchResults[indexPath.row] : self.endSearchResults[indexPath.row]
        
        //Create a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle

        return cell
    }
    
    
    
}

extension InsertViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let result = tableView == self.startTableView ? self.startSearchResults[indexPath.row] : self.endSearchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }

            guard let name = response?.mapItems[0].name else {
                 return
            }

            
            let lat = coordinate.latitude
            let lon = coordinate.longitude

            print(lat)
            print(lon)
            print(name)

        }
    }
}

extension InsertViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar == self.startSearchBar {
            self.startSearchCompleter.queryFragment = searchText
        } else {
            self.endSearchCompleter.queryFragment = searchText
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == self.startSearchBar {
            self.startTableHeight.constant = tableHeight()
            
        } else {
            self.endTableHeight.constant = tableHeight()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar == self.startSearchBar {
            self.startTableHeight.constant = 0
            
        } else {
            self.endTableHeight.constant = 0
        }
    }
}

extension InsertViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        if completer == self.startSearchCompleter {
            self.startSearchResults = completer.results
            self.startTableView.reloadData()
        } else {
            self.endSearchResults = completer.results
            self.endTableView.reloadData()
        }
        
    }

    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
}
