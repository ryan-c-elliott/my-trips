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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fileTextBox: UITextField!
    @IBOutlet weak var fileLabel: UILabel!
    
    var components: Components = Components()
    var dateFormatter: DateFormatter = DateFormatter()
    var timeFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parent = self.parent as! TabBarController
        
        self.components = parent.data.components
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.locale = Locale(identifier: "en_US")
        self.timeFormatter = parent.timeFormatter
        
        // DatePickers
        let today = Date()
        var min = today
        self.fromDatePicker.maximumDate = today
        self.toDatePicker.maximumDate = today
        if self.components.tripCount > 0 {
            min = components.get(row: 0, section: 0).startDate
            
        }
        self.fromDatePicker.minimumDate = min
        self.toDatePicker.minimumDate = min
        self.fromDatePicker.setDate(min, animated: false)
        
        // Labels
        self.clearLabels()
        
        // TextBox
        self.fileTextBox.autocorrectionType = .no
        
        
        // Do any additional setup after loading the view.
    }
    
    func clearLabels() {
        self.dateLabel.text = ""
        self.fileLabel.text = ""
    }
    

    @IBAction func exportButtonTapped(_ sender: UIButton) {
        if self.fromDatePicker.date > self.toDatePicker.date {
            self.dateLabel.text = "Choose a valid date range"
            return
        }
        self.clearLabels()
        let text = self.fileTextBox.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "" {
            self.fileLabel.text = "You need to enter a filename"
            return
        }
        self.clearLabels()
        let items: [Any] = [createCSV(filename: text)]
        
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.excludedActivityTypes = [.addToReadingList,.assignToContact,.saveToCameraRoll,.postToFacebook,.postToWeibo,.postToVimeo,.postToFlickr,.postToTwitter,.postToTencentWeibo]
        
        present(ac, animated: true)
    }
    
    func createCSV(filename: String) -> URL {
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(filename).csv")!
        var csvText = "Date,Start Time,End Time,Distance\n"
        
        
        
        let iterator = self.components.makeIterator(start: self.fromDatePicker.date, end: self.toDatePicker.date)
        
        while let next = iterator.next() {
            let date = self.dateFormatter.string(from: next.startDate)
            let startTime = self.timeFormatter.string(from: next.startDate)
            let endTime = self.timeFormatter.string(from: next.endDate)
            let distance = next.distance
            let newline = "\(date),\(startTime),\(endTime),\(distance)\n"
            csvText.append(newline)
        }
        
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        return path
 
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
