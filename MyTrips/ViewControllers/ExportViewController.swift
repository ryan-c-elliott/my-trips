//
//  ExportViewController.swift
//  MyTrips
//
//  Created by Ryan Elliott on 8/2/21.
//

import UIKit

class ExportViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fileTextBox: UITextField!
    @IBOutlet weak var fileLabel: UILabel!
    
    var tripData: TripData = TripData()
    var dateFormatter: DateFormatter = DateFormatter()
    var timeFormatter: DateFormatter = DateFormatter()
    
    func reloadData() {
        // DatePickers
        let today = Date()
        let min = self.tripData.get(row: 0, section: 0)?.getStartDate() ?? today
        
        self.fromDatePicker.maximumDate = today
        self.toDatePicker.maximumDate = today
        self.fromDatePicker.minimumDate = min
        self.toDatePicker.minimumDate = min
        self.fromDatePicker.setDate(min, animated: false)
        
        // Labels
        self.clearLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.parent as! TabBarController
        
        self.tripData = parent.data.tripData
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.timeFormatter = parent.timeFormatter
        
        // TextBox
        self.fileTextBox.autocorrectionType = .no
        self.fileTextBox.returnKeyType = .done
        
        // Reload
        self.reloadData()
        

    }
    
    /* * Actions * */
    
    @IBAction func dateValueDoneEditing(_ sender: UIDatePicker) {
  
        // If dates aren't messed up then return
        if self.fromDatePicker.date < self.toDatePicker.date {
            return
        }
        
        // Set dates to be the same as sender
        if sender == self.fromDatePicker {
            self.toDatePicker.date = self.fromDatePicker.date
        } else {
            self.fromDatePicker.date = self.toDatePicker.date
        }
        
        
        
    }

    @IBAction func exportButtonTapped(_ sender: UIButton) {
        self.clearLabels()
        
        // Trim whitespace
        let text = self.fileTextBox.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // If no text is entered
        if text == "" {
            self.fileLabel.text = "You need to enter a filename"
            return
        }
        
        self.clearLabels()
        
        // Get rid of keyboard
        self.doneWithKeyboard(fileTextBox)
        
        // Create file
        guard let file = createCSV(filename: text) else {
            self.csvFailedToWrite()
            return
        }
        
        // Present view that allows user to choose where to send the file
        let ac = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        ac.excludedActivityTypes = [.addToReadingList,.assignToContact,.saveToCameraRoll,.postToFacebook,.postToWeibo,.postToVimeo,.postToFlickr,.postToTwitter,.postToTencentWeibo]
        
        present(ac, animated: true)
    }

    @IBAction func doneWithKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /* * Helpers * */
    
    func clearLabels() {
        self.fileLabel.text = ""
    }
    
    func createCSV(filename: String) -> URL? {
        
        guard let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(filename).csv") else {
            return nil
        }
        var csvText = "Date,Start Time,End Time,Distance\n"
        
        let end = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: self.toDatePicker.date)!
        
        let iterator = self.tripData.makeIterator(start: self.fromDatePicker.date, end: end)
        
        var totalDistance = 0.0
        while let next = iterator.next() {
            let date = self.dateFormatter.string(from: next.getStartDate())
            let startTime = self.timeFormatter.string(from: next.getStartDate())
            let endTime = self.timeFormatter.string(from: next.getEndDate())
            let distance = next.distance
            let newline = "\(date),\(startTime),\(endTime),\(distance)\n"
            totalDistance += distance
            csvText.append(newline)
        }
        csvText.append(",,Total,\(totalDistance)")
        
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
            return nil
        }
        
        return path
 
    }
    
    /* * Alerts * */
    
    func csvFailedToWrite() {
        
        let alert = UIAlertController(title: "Error!", message: "Unable to create file. Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        
        ))
        
        self.present(alert, animated: true, completion: nil)

    }
    
}
