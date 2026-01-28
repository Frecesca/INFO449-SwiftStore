//
//  SKU.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

// Represents a scannable item in the store.
protocol SKU {
    var name: String { get }
    func price() -> Int   // Price in pennies
}
