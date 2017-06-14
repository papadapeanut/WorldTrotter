//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Jason Moore on 6/3/17.
//  Copyright © 2017 Jason Moore. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
        //Class variables
        var mapView: MKMapView!
        var locationButton: UIButton!
        let locationMgr = CLLocationManager()
        var currentLocation = CLLocation()
        var austinBirthLocation = MKPointAnnotation()
        var ourHouse = MKPointAnnotation()
        var zion = MKPointAnnotation()
        var myLocations: [MKPointAnnotation] = []
        var locationCount = 0
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //set it as *the* view of this view controller
        view = mapView
        
        austinBirthLocation.coordinate = CLLocationCoordinate2DMake(39.3128818, -84.5176661)
        ourHouse.coordinate = CLLocationCoordinate2DMake(39.365878, -84.413761)
        zion.coordinate = CLLocationCoordinate2DMake(37.288370, -112.978922)
        mapView.addAnnotation(austinBirthLocation)
        mapView.addAnnotation(ourHouse)
        mapView.addAnnotation(zion)
        myLocations = [austinBirthLocation, ourHouse, zion]
        
        //Segmented control for map view options
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        view.addSubview(segmentedControl)
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        //Setting contraints for segmented control
        let topContraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topContraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        //Creating find me button and constraints
        locationButton = UIButton()
        view.addSubview(locationButton)
        locationButton.setTitle("Find Me", for: .normal)
        locationButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        locationButton.layer.cornerRadius = 3
        locationButton.sizeToFit()
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        locationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    
        //Creating my locations button and constraints
        let myLocationsButton = UIButton()
        view.addSubview(myLocationsButton)
        myLocationsButton.setTitle("My Locations", for: .normal)
        myLocationsButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        myLocationsButton.layer.cornerRadius = 3
        myLocationsButton.sizeToFit()
        myLocationsButton.translatesAutoresizingMaskIntoConstraints = false
        myLocationsButton.addTarget(self, action: #selector(myLocationsButtonTouched), for: .touchUpInside)
        myLocationsButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        myLocationsButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUserGPSLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationMgr.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    func myLocationsButtonTouched(_ btn: UIButton){
        print("My Locations button was touched")
        UIView.animate(withDuration: 0.1,
                       animations: {
                        btn.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            btn.transform = CGAffineTransform.identity
                        }
        })
        if locationCount < myLocations.count {
            mapView.region.center.latitude = myLocations[locationCount].coordinate.latitude
            mapView.region.center.longitude = myLocations[locationCount].coordinate.longitude
            locationCount += 1
        }else {
            locationCount = 0
            mapView.region.center.latitude = myLocations[locationCount].coordinate.latitude
            mapView.region.center.longitude = myLocations[locationCount].coordinate.longitude
            locationCount += 1
        }
 
    }
    
    func locationButtonTapped(_ btn: UIButton){
        print("Find me button was pressed")
        UIView.animate(withDuration: 0.1,
                       animations: {
                        btn.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            btn.transform = CGAffineTransform.identity
                        }
        })
        
        mapView.region.center.latitude = currentLocation.coordinate.latitude
        mapView.region.center.longitude = currentLocation.coordinate.longitude
    }
    
    func setUserGPSLocation(){
       
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
        
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        print("Current location: \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
}
