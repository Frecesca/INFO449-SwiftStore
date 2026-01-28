//
//  Item.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

// fixed price per unit
class Item: SKU {

    var name: String
    var priceEach: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }

    func price() -> Int {
        return priceEach
    }
}
