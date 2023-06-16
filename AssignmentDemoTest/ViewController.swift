//
//  ViewController.swift
//  AssignmentDemoTest
//
//  Created by akash dhomne on 14/06/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mainVC: UIView!
    @IBOutlet weak var userList: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnmail: UIButton!
    @IBOutlet weak var btnMobileNo: UIButton!
    
    @IBOutlet weak var mapview: MKMapView!
    
    
    let viewModel = UserlistViewModel()
    var userDetails = [Resultvalue]()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewModelObserver()
        setup()
        fetchUserList()
       displayUserLogs()
    }
    
    func setup()
    {
        self.view.backgroundColor = .white
        imgProfile.setRounded()
    }
    @IBAction func btnMailClicked(_ sender: UIButton) {
        let activity = "User click on mail"
        logUserActivity(activity: activity)
        openEmailApp(email:sender.titleLabel?.text as! String)
        
    }
    @IBAction func btnMobileClicked(_ sender: UIButton) {
        let activity = "User click on Phone"
        logUserActivity(activity: activity)
        callNumber(phoneNumber: sender.titleLabel?.text as! String)
    }
    
    
    
    
    
    
}

//MARK: Private Methods

extension ViewController {
    
    func fetchUserList() {
        viewModel.fetchUserList()
    }
    
    func prepareViewModelObserver() {
        self.viewModel.usersDidChanges = { (finished, error) in
            if !error {
                self.setProfileData()
            }
            else
            {
                self.showAlert()
            }
        }
    }
    
    func setProfileData()
    {
        
        if let profileData = viewModel.users?.first
        {
            print(profileData)
            let url = URL(string: profileData.picture.large)!
               downloadImage(from: url)
            lblName.text = "\(profileData.name.title) \(profileData.name.first) \(profileData.name.last)"
            btnmail.setTitle(profileData.email, for: .normal)
            btnMobileNo.setTitle(profileData.phone, for: .normal)
            setMapData(lat: Double(profileData.location.coordinates.latitude) ?? 0.0,lon: Double(profileData.location.coordinates.longitude) ?? 0.0)
            let activity = "User view proifile"
            logUserActivity(activity: activity)
        }
       
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imgProfile.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func openEmailApp(email: String) {
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
        
    }
    
    private func callNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    func setMapData(lat:Double,lon:Double)
    {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        print(location)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
              let region = MKCoordinateRegion(center: location, span: span)
              mapview.setRegion(region, animated: true)
              
              let annotation = MKPointAnnotation()
              annotation.coordinate = location
            annotation.title = "\(lblName.text!)"
              mapview.addAnnotation(annotation)
    }
    
    
    // Function to log user activity
    func logUserActivity(activity: String) {
        // Get existing logs or initialize an empty array
        var logs = UserDefaults.standard.stringArray(forKey: "userLogs") ?? []

        // Add the new activity to the logs with a timestamp
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        let logEntry = "\(timestamp): \(activity)"
        logs.append(logEntry)

        // Store the updated logs in user defaults
        UserDefaults.standard.set(logs, forKey: "userLogs")
    }

    // Function to retrieve user logs
    func getUserLogs() -> [String] {
        // Get logs from user defaults
        let logs = UserDefaults.standard.stringArray(forKey: "userLogs") ?? []
        return logs
    }
    
    func displayUserLogs() {
            let logs = getUserLogs()
            for log in logs {
                print(log) // Or update your UI to display the logs
            }
        }
    // Display an alert message
    func showAlert() {
        let alertController = UIAlertController(title: "Api", message: "Api error message", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

