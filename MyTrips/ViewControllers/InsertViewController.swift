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
    
    @IBOutlet weak var startTableHeight: NSLayoutConstraint!
    @IBOutlet weak var endTableHeight: NSLayoutConstraint!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        self.startTableView.delegate = self
        self.startTableView.dataSource = self
        self.endTableView.delegate = self
        self.endTableView.dataSource = self
        
        // Search
        self.searchCompleter.delegate = self
        self.startSearchBar.delegate = self
        self.endSearchBar.delegate = self
        
        
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

extension InsertViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = self.searchResults[indexPath.row]
        
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

        let result = self.searchResults[indexPath.row]
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
        self.searchCompleter.queryFragment = searchText
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == self.startSearchBar {
            self.endTableView.
        } else {
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        <#code#>
    }
}

extension InsertViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        self.searchResults = completer.results

        // Reload the tableview with our new searchResults
        self.startTableView.reloadData()
    }

    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
}
