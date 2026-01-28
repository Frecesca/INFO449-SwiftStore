//
//  Item.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//


import Foundation

class Item: SKU, Taxable {

    var name: String
    var priceEach: Int

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }

    func price() -> Int {
        return priceEach
    }

    // Food is not taxed. Non-food is taxed at 10%.
    func tax() -> Int {
        let lower = name.lowercased()

        // simple edible check (good enough for this assignment)
        if lower.contains("beans") ||
           lower.contains("banana") ||
           lower.contains("apple") ||
           lower.contains("steak") ||
           lower.contains("granols") {
            return 0
        }

        // 10% tax, round down
        return (priceEach * 10) / 100
    }
}

