//
//  ProductModel.swift
//  
//
//  Created by Nayan Bhut on 5/15/22.
//

import Fluent
import Vapor

final class ProductModel: Model, Content, Authenticatable {
    static let schema = "products"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension ProductModel: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(
            "name",
            as: String.self,
            is: !.empty && .count(2...),
            customFailureDescription: "Please enter valid Product Name"
        )
    }
}
