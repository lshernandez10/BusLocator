//
//  Stop.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit

class Stop: NSObject {
    
    var lat:Double!
    var long:Double!
    
    //Para asegurar que hay un constructor
    override init() {
        super.init()
    }
    
    //Se necesita que por parametro le entre al Bus un diccionario (JSON) del que toma los valores para poblar los atributos
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        lat = dictionary["lat"] as! Double
        long = dictionary["lng"] as! Double
        
    }
}

