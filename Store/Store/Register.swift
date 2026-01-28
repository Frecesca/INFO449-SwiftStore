//
//  Register.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

class Register {

    var receipt: Receipt
    var pricing: PricingScheme?

    init() {
        receipt = Receipt()
        pricing = nil
    }

    func setPricing(_ scheme: PricingScheme) {
        pricing = scheme
    }

    func scan(_ sku: SKU) {
        receipt.add(sku)
    }

    // tax for all taxable items on the receipt
    func taxTotal() -> Int {
        var tax = 0

        for sku in receipt.items() {
            if let t = sku as? Taxable {
                tax += t.tax()
            }
        }

        return tax
    }

    // Shows the running total without ending the transaction.
    func subtotal() -> Int {
        // apply pricing scheme first (if any)
        var sub = 0
        if pricing == nil {
            sub = receipt.total()
        } else {
            sub = pricing!.total(for: receipt)
        }

        // add tax on top
        return sub + taxTotal()
    }

    // Ends the current transaction and starts a new one.
    func total() -> Receipt {
        // store tax info on the receipt so output() can show it
        receipt.taxAmount = taxTotal()

        let completed = receipt
        receipt = Receipt()
        return completed
    }
}
