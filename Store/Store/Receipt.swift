//
//  Receipt.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

// Receipt represents the entire transaction.
// It stores all scanned SKUs for one purchase.
class Receipt {

    // List of all items scanned in this transaction
    var scanned: [SKU]

    // Total tax for this receipt (in pennies)
    var taxAmount: Int

    init() {
        scanned = []
        taxAmount = 0
    }

    // Add a scanned item to the receipt
    func add(_ sku: SKU) {
        scanned.append(sku)
    }

    // Returns the list of all scanned SKUs
    func items() -> [SKU] {
        return scanned
    }

    // Calculates the subtotal price of all items (before tax)
    func total() -> Int {
        var sum = 0

        for sku in scanned {
            sum += sku.price()
        }

        return sum
    }

    // Formats a price in pennies into a dollar string (e.g. $1.99)
    func formatMoney(_ pennies: Int) -> String {
        let dollars = pennies / 100
        let cents = pennies % 100

        if cents < 10 {
            return "$\(dollars).0\(cents)"
        } else {
            return "$\(dollars).\(cents)"
        }
    }

    // Outputs the receipt showing all items, tax, and final total
    func output() -> String {
        var result = ""
        result += "Receipt:\n"

        for sku in scanned {
            result += "\(sku.name): \(formatMoney(sku.price()))\n"
        }

        result += "------------------\n"
        result += "SUBTOTAL: \(formatMoney(total()))\n"
        result += "TAX: \(formatMoney(taxAmount))\n"
        result += "TOTAL: \(formatMoney(total() + taxAmount))"

        return result
    }
}
