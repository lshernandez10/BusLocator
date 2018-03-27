//
//  ViewController.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableViewBuses: UITableView!
    var buses:[Bus] = [Bus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewBuses.delegate = self
        tableViewBuses.dataSource = self
        
        getBuses{ (buses: [Bus]? ) in
            if buses != nil {
                self.buses = buses!
                DispatchQueue.main.async {
                    self.tableViewBuses.reloadData()
                }
            } else {
                print("Hubo un error al obtener los datos.")
            }
        }
    }
    
    func getBuses(_ completion: @escaping (_ success: [Bus]?) -> ()) {
        
        //Petición Buses
        manager.get("/bins/10yg1t", parameters: nil, progress: { (progress) in }, success: { (task: URLSessionDataTask, response) in let dicResponse: NSDictionary = response! as! NSDictionary
            
            var buses : [Bus] = [Bus]()
            for (i, item) in (dicResponse["school_buses"]! as! NSArray).enumerated() {
                var bus = item as! Dictionary<String,AnyObject>
                
                //Petición bus stops
                let stopUrl = bus["stops_url"] as! String
                let path = stopUrl.split(separator: "/")[3]
                manager.get("/bins/\(path)", parameters: nil, progress: { (progress) in }, success: { (task: URLSessionDataTask, response) in let dicResponse: NSDictionary = response! as! NSDictionary
                    
                    var stops : [Stop] = [Stop]()
                    for item in dicResponse["stops"]! as! NSArray {
                        
                        let currentStop:Stop = Stop(item as! Dictionary<String,AnyObject>)
                        stops.append(currentStop)
                    }
                    buses[i].stops = stops
                    
                })
                //---Terminó Petición bus stops
                
                let currentBus:Bus = Bus(bus)
                buses.append(currentBus)
            }
            completion(buses)
            
        }) { (task: URLSessionDataTask?, error: Error) in print("Error task: \(String(describing: task))  -- Error Response \(error)")
            completion(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "BusCell", for: indexPath)
        
        //Bus en la posición actual
        let currentBus:Bus = buses[indexPath.row]
        
        //Referencia a la vista de la imagen en la celda
        let imageView:UIImageView = cell.viewWithTag(1) as! UIImageView
        donwloadImage(url: URL(string: currentBus.image)!, imageView: imageView)
        
        //Referencia label nombre
        let labelNombre:UILabel = cell.viewWithTag(2) as! UILabel
        labelNombre.text = currentBus.name
        
        //Referencia label descripción
        let labelPrecio:UILabel = cell.viewWithTag(3) as! UILabel
        labelPrecio.text = String(currentBus.descrip)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busSeleccionado:Bus = buses[indexPath.row]
        self.performSegue(withIdentifier: "goToBusStops", sender: busSeleccionado)
    }
    
    //Descargar imagenes - manejo de hilos
    func donwloadImage(url: URL, imageView:UIImageView) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.getDataFromURL(url: url){ (data, response, error) in
                guard let data = data, error == nil else {return}
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func getDataFromURL (url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    //Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToBusStops" {
            let viewController: BusStopsViewController = segue.destination as! BusStopsViewController
            viewController.busSeleccionado = sender as! Bus
        }
    }

}


