//
//  OrderProductModel.swift
//  
//
//  Created by Nayan Bhut on 5/15/22.
//

import Fluent
import Vapor

final class OrderProductModel: Model, Content {
    static let schema = "order_products"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "order_id") var orderId: UUID
    @Field(key: "product_id") var productId: UUID
    @Field(key: "quantity") var quantity: Int
    
    init() { }
    
    init(id: UUID? = nil, orderId: UUID, productId: UUID, quantity: Int) {
        self.id = id
        self.orderId = orderId
        self.productId = productId
        self.quantity = quantity
    }
}
