//
//  RainCheckPricing.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation


class RainCheckPricing: PricingScheme {

    let itemName: String
    let newPrice: Int

    // newPrice is the honored price (in pennies)
    init(itemName: String, newPrice: Int) {
        self.itemName = itemName
        self.newPrice = newPrice
    }

    func total(for receipt: Receipt) -> Int {
        let items = receipt.items()

        var applied = false
        var adjustment = 0

        for sku in items {
            if !applied && sku.name == itemName {
                // replace original price with rain check price (one item only)
                adjustment = sku.price() - newPrice
                applied = true
            }
        }

        return receipt.total() - adjustment
    }
}
