//
//  BusStopsViewController.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

struct GoogleResponse: Codable {
    let routes: [Routes]
}

struct Routes: Codable {
    let legs: [Legs]
}

struct Legs: Codable {
    let steps: [Steps]
}

struct Steps: Codable {
    let distance: TextValue
    let duration: TextValue
    let start_location: Location
    let end_location: Location
    let polyline: Polyline
}

struct TextValue: Codable {
    let text: String
    let value: Int
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct Polyline: Codable {
    let points: String
}
class BusStopsViewController: UIViewController, CLLocationManagerDelegate {

    //Outlets
    @IBOutlet weak var navBarTittle: UINavigationItem!
    @IBOutlet weak var mapView: GMSMapView!
    
    //Vars
    var busSeleccionado: Bus!
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarTittle.title = busSeleccionado.name

        for (index, item) in busSeleccionado.stops.enumerated() {
            let stop:Stop = item as! Stop
            showMarker(lat: stop.lat, long: stop.long)
            if index+1 < busSeleccionado.stops.count {
                let nextStop = busSeleccionado.stops[index+1] as! Stop
                let stop:Stop = item as! Stop
                showMarker(lat: stop.lat, long: stop.long)
                let origin = CLLocation(latitude: stop.lat, longitude: stop.long)
                let destination = CLLocation(latitude: nextStop.lat, longitude: nextStop.long)
                drawPath(startLocation: origin, endLocation: destination)
            } 
            
        }
    }
    
    func showMarker(lat: Double, long: Double){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyC6qmjITVxrR5HeTgJ_nl6BYilDCVhTl0Y"
        print("URL: \(url)")
        
        Alamofire.request(url).responseJSON { response in
            print("responde data")
            print(response.response as Any)
            
            let decoder = JSONDecoder()
            let json = try! decoder.decode(GoogleResponse.self, from: response.data!)
            let routes = json.routes
            
            for route in routes {
                let legs = route.legs
                for leg in legs {
                    let steps = leg.steps
                    for step in steps {
                        let points = step.polyline.points
                        let path = GMSPath.init(fromEncodedPath: points)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 4
                        polyline.strokeColor = UIColor.red
                        polyline.map = self.mapView
                    }
                }
            }
        }
    }

    
    @IBAction func closeStops(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
