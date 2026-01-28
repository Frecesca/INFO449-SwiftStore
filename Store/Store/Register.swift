//
//  Register.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

class Register {

    var receipt: Receipt

    init() {
        receipt = Receipt()
    }

    func scan(_ sku: SKU) {
        receipt.add(sku)
    }

    // Shows the running total without ending the transaction.
    func subtotal() -> Int {
        return receipt.total()
    }

    // Ends the current transaction and starts a new one.
    func total() -> Receipt {
        let completed = receipt
        receipt = Receipt()
        return completed
    }
}
