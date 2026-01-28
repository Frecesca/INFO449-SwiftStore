//
//  WeightedItem.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//


import Foundation

class WeightedItem: SKU {

    var name: String
    var pricePerPound: Int
    var pounds: Double

    init(name: String, pricePerPound: Int, pounds: Double) {
        self.name = name
        self.pricePerPound = pricePerPound
        self.pounds = pounds
    }

    func price() -> Int {
        let raw = Double(pricePerPound) * pounds
        // round to nearest penny (0.5 rounds up)
        return Int(raw.rounded())
    }
}
