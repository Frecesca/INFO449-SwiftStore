//
//  Taxable.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

protocol Taxable {
    // Return tax in pennies for this item.
    func tax() -> Int
}
