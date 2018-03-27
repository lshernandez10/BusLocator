//
//  BusStopsViewController.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit
import GoogleMaps

class BusStopsViewController: UIViewController {

    //Outlets
    @IBOutlet weak var navBarTittle: UINavigationItem!
    @IBOutlet weak var mapView: GMSMapView!
    
    //Vars
    var busSeleccionado: Bus!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarTittle.title = busSeleccionado.name

        for item in busSeleccionado.stops {
            let stop:Stop = item as! Stop
            showMarker(lat: stop.lat, long: stop.long)
        }
    }
    
    func showMarker(lat: Double, long: Double){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
    }
    
    @IBAction func closeStops(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
