//
//  Order.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import Foundation

struct Order {
    
    var created: NSNumber
    var orderId: NSString
    var username: NSString //of the user who created the order
    var total: Double
    var items: [Item]
    var notes: NSString?
    var active: Bool {
        if activeString.contains("Yes") {
            return true
        }
        return false
    }

    var activeString: NSString
}
