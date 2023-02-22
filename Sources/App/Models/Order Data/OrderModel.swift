//
//  OrderModel.swift
//  
//
//  Created by Nayan Bhut on 5/15/22.
//

import Fluent
import Vapor

final class OrderModel: Model, Content {
    static let schema = "orders"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "date") var date: Date
    @Field(key: "customer_id") var customerId: UUID
    
    init() { }
    
    init(id: UUID? = nil, date: Date, customerId: UUID) {
        self.id = id
        self.date = date
        self.customerId = customerId
    }
}
