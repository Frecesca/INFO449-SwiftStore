//
//  TwoForOnePricing.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

class TwoForOnePricing: PricingScheme {

    let itemName: String

    init(itemName: String) {
        self.itemName = itemName
    }

    func total(for receipt: Receipt) -> Int {
        let items = receipt.items()

        var matchCount = 0
        var unitPrice = 0

        for sku in items {
            if sku.name == itemName {
                matchCount += 1
                unitPrice = sku.price()
            }
        }

        if matchCount < 3 {
            return receipt.total()
        }

        let freeCount = matchCount / 3
        let discount = freeCount * unitPrice

        return receipt.total() - discount
    }
}
