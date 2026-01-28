//
//  PricingScheme.swift
//  Store
//
//  Created by 8888 on 1/27/26.
//

import Foundation

protocol PricingScheme {
    func total(for receipt: Receipt) -> Int
}
