//
//  CustomerModel.swift
//  
//
//  Created by Nayan Bhut on 5/15/22.
//

import Vapor
import Fluent

final class CustomerModel: Model, Content {
    static let schema = "customers"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "name") var name: String
    
    init() { }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

