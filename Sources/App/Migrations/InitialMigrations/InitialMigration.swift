//
//  File.swift
//  
//
//  Created by Nayan Bhut on 2/18/23.
//

import Foundation
import Fluent
import Vapor

class InitialMigrations: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        
        try await database.schema(CustomerModel.schema)
            .id()
            .field("name", .string, .required)
            .create()
        
        try await database.schema(OrderModel.schema)
            .id()
            .field("date", .date, .required)
            .field("customer_id", .uuid, .required)
            .foreignKey("customer_id", references: CustomerModel.schema, .id,onDelete: .cascade)
            .create()
        
        try await database.schema(ProductModel.schema)
            .id()
            .field("name", .string, .required)
            .create()
        
        try await database.schema(OrderProductModel.schema)
            .id()
            .field("order_id", .uuid, .required)
            .foreignKey("order_id", references: OrderModel.schema, .id, onDelete: .cascade)
            .field("product_id", .uuid, .required)
            .foreignKey("product_id", references: ProductModel.schema, .id, onDelete: .cascade)
            .field("quantity", .int, .required)
            .unique(on: "order_id", "product_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(OrderProductModel.schema).delete()
        try await database.schema(CustomerModel.schema).delete()
        try await database.schema(OrderModel.schema).delete()
        try await database.schema(ProductModel.schema).delete()
    }
}
