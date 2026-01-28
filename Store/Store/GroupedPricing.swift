//
//  GroupedPricing.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

class GroupedPricing: PricingScheme {

    let groupA: String
    let groupB: String
    let percentOff: Int

    // percentOff: 10 means 10% off
    init(groupA: String, groupB: String, percentOff: Int) {
        self.groupA = groupA.lowercased()
        self.groupB = groupB.lowercased()
        self.percentOff = percentOff
    }

    func total(for receipt: Receipt) -> Int {
        let items = receipt.items()

        var hasA = false
        var hasB = false

        for sku in items {
            let n = sku.name.lowercased()
            if n.contains(groupA) {
                hasA = true
            }
            if n.contains(groupB) {
                hasB = true
            }
        }

        if !(hasA && hasB) {
            return receipt.total()
        }

        // apply discount to all items in A and B
        var discount = 0
        for sku in items {
            let n = sku.name.lowercased()
            if n.contains(groupA) || n.contains(groupB) {
                // 10% off => discount = price * 10 / 100
                discount += (sku.price() * percentOff) / 100
            }
        }

        return receipt.total() - discount
    }
}

