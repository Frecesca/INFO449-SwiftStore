//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
SUBTOTAL: $1.99
TAX: $0.00
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())

        register.scan(Item(name: "Pencil", priceEach: 99))
        // tax for pencil = 9, so subtotal includes tax
        XCTAssertEqual(307, register.subtotal())

        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        // granols treated as food => no tax, so total tax still 9
        XCTAssertEqual(806, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
SUBTOTAL: $7.97
TAX: $0.09
TOTAL: $8.06
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }

    // EXTRA CREDIT: 2-for-1 pricing (buy 3 pay 2)
    func testTwoForOnePricing() {
        register.setPricing(TwoForOnePricing(itemName: "Beans (8oz Can)"))

        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        // 3 beans => pay 2 => 398, tax 0
        XCTAssertEqual(398, register.subtotal())
    }
    
    // EXTRA CREDIT: grouped pricing (ketchup + beer => 10% off each)
    func testGroupedPricingKetchupBeer() {
        register.setPricing(GroupedPricing(groupA: "ketchup", groupB: "beer", percentOff: 10))

        register.scan(Item(name: "Ketchup (Heinz)", priceEach: 300))
        register.scan(Item(name: "Beer (IPA 6-pack)", priceEach: 1000))

        // base = 1300
        // discount = 10% of 300 + 10% of 1000 = 30 + 100 = 130
        // discounted subtotal = 1170
        // tax = 10% of 300 + 10% of 1000 = 30 + 100 = 130
        // register.subtotal includes tax => 1170 + 130 = 1300
        XCTAssertEqual(1300, register.subtotal())
    }
    
    // EXTRA CREDIT: priced by weight
    func testWeightedItemPrice() {
        // $8.99/lb, 1.10 lb => 8.99 * 1.10 = 9.889 => rounds to 9.89 => 989 pennies
        register.scan(WeightedItem(name: "Steak", pricePerPound: 899, pounds: 1.10))
        XCTAssertEqual(989, register.subtotal())
    }
    
    // EXTRA CREDIT: coupon (15% off one item)
    func testCouponOneItemOnly() {
        register.setPricing(CouponPricing(itemName: "Beans (8oz Can)", percentOff: 15))

        register.scan(Item(name: "Beans (8oz Can)", priceEach: 200))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 200))

        // base = 400
        // coupon applies to ONE item only: 15% of 200 = 30
        // subtotal = 370, tax 0
        XCTAssertEqual(370, register.subtotal())
    }
    
    // EXTRA CREDIT: rain check replaces price of one item
    func testRainCheckPricing() {
        register.setPricing(RainCheckPricing(itemName: "Beans (8oz Can)", newPrice: 150))

        register.scan(Item(name: "Beans (8oz Can)", priceEach: 200))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 200))

        // base = 400
        // rain check replaces ONE item price: 200 -> 150 (discount 50)
        // subtotal = 350, tax 0
        XCTAssertEqual(350, register.subtotal())
    }

    // EXTRA CREDIT: tax on non-food items (10%, round down)
    func testTaxNonFood() {
        register.scan(Item(name: "Pencil", priceEach: 99))

        // 99 + tax(9) = 108
        XCTAssertEqual(108, register.subtotal())

        let receipt = register.total()
        XCTAssertEqual(99, receipt.total())
        XCTAssertEqual(9, receipt.taxAmount)

        let expectedReceipt = """
Receipt:
Pencil: $0.99
------------------
SUBTOTAL: $0.99
TAX: $0.09
TOTAL: $1.08
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }

    // EXTRA CREDIT: food should not be taxed
    func testTaxFoodIsZero() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))

        // no tax
        XCTAssertEqual(199, register.subtotal())

        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())
        XCTAssertEqual(0, receipt.taxAmount)

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
SUBTOTAL: $1.99
TAX: $0.00
TOTAL: $1.99
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}

