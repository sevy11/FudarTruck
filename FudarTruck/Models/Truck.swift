//
//  Truck.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import Foundation
import FirebaseAuth

final class Truck: User {
    //var truckId: String
    var name: NSString
    var desciption: NSString?
    //var email: NSString
    //var password: NSString
    var lat: NSString?
    var lon: NSString?
    var menu: [Item]?
    var queue: [Order]?
    var rating: Double?
//    var waitTime: Double {
//        if let wait = wait {
//            return wait
//        }
//        return 0.0
//    }
//
//    var truckAvatar: URL? {
//        guard let urlString: imageString else { return nil }
//        return URL(urlString)
//    }
//    var wait: Double
//    var imageString: String? = ""

    public init(name: NSString) {
        self.name = name


    }
}


