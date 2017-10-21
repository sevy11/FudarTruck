//
//  Item.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import Foundation

struct Item {
    var itemId: NSString
    var name: NSString
    var description: NSString?
    var price: Double
    var image: URL? {
        guard let imageURL = imageString else { return nil }
        return URL(imageURL)
    }
    var discount: Double // 0 to 1

    var imageString: String?
}
