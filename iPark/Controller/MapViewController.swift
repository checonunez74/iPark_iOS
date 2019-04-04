//
//  MapViewController.swift
//  iPark
//
//  Created by Sergio Nunez on 1/28/19.
//  Copyright © 2019 Sergio Nunez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import Firebase

class MapViewController: UIViewController {
    
    //creating object for location
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding a signout button programmatictly
        let signoutButton = UIBarButtonItem(title: "Signout", style: .done, target: self, action: #selector(signOutTapped))
        self.navigationItem.rightBarButtonItem = signoutButton
        
        // call for function that will check for location services
        checkLocationServices()

    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // function to show users location on map
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(location, regionInMeters, regionInMeters) //new format for init()
            map.setRegion(region, animated: true)
        }
    }
    
    // Checking status of Location Services
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            // setup the laocgtion manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert asking the user to turn on Location Services
        }
    }
    
    // Requesting authorization to obtain location from user
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Work with the MAP's code
            map.showsUserLocation = true //places blue dot on map
            centerViewOnUserLocation() //calls function to zoom in on user's current location
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert to let them know how to turn on permisions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show them there is a restriction in their phone
            break
        case .authorizedAlways:
            break
        }
    }

    
    //Action to signout from the app
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "MapToSignIn", sender: nil)
        }catch{
            print(error.localizedDescription)
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
 
    
    //Function to auto upadate the location of the user in realtime
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, regionInMeters, regionInMeters)
        map.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
}
