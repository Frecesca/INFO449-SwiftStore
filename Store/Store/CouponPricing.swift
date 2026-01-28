//
//  CouponPricing.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation


class CouponPricing: PricingScheme {

    let itemName: String
    let percentOff: Int

    init(itemName: String, percentOff: Int) {
        self.itemName = itemName
        self.percentOff = percentOff
    }

    func total(for receipt: Receipt) -> Int {
        let items = receipt.items()

        // find one matching item (only one line item gets discounted)
        var discount = 0
        var found = false

        for sku in items {
            if !found && sku.name == itemName {
                discount = (sku.price() * percentOff) / 100
                found = true
            }
        }

        return receipt.total() - discount
    }
}
