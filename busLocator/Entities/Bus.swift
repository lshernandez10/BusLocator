//
//  Bus.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit

class Bus: NSObject {
    
    var id:Int!
    var name:String!
    var descrip:String!
    var stops:Array<Any>!
    var image:String!
    
    //Para asegurar que hay un constructor
    override init() {
        super.init()
    }
    
    //Se necesita que por parametro le entre al Bus un diccionario (JSON) del que toma los valores para poblar los atributos
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        
        id = dictionary["id"] as! Int
        name = dictionary["name"] as! String
        descrip = dictionary["description"] as! String
        image = dictionary["img_url"] as! String
        
    }
}
