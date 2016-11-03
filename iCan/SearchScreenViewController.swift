//
//  SearchScreenViewController.swift
//  uService
//
//  Created by Kendrick Choate on 11/3/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit
import MapKit

class SearchScreenViewController: UIViewController, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        var currentLocation = CLLocation()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location!
            
        }
        let regionRadius: CLLocationDistance = 5000.0
        let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchScreenViewController: CLLocationManagerDelegate {
    
}
