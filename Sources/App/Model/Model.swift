//
//  File.swift
//  
//
//  Created by Nayan Bhut on 4/30/22.
//

import Foundation
import Vapor

struct Hello: Content {
    var name: String?
}

struct Greeting: Content {
    var hello: String
}

struct Profile: Content {
    var name: String
    var email: String
    var image: Data
}

enum Color: String, Codable {
    case red, blue, green
}

struct CreateUser: Content {
    var name: String
    var username: String
    var age: Int
    var email: String
    var favoriteColor: Color?
}

extension CreateUser: Validatable {
    static func validations(_ validations: inout Validations) {
        // Validations go here.
        validations.add("email", as: String.self, is: .email)
        validations.add("username", as: String.self, is: .count(3...) && .alphanumeric)
        validations.add("age", as: Int.self, is: .range(13...))
        validations.add(
            "favoriteColor", as: String?.self,
            is: .in("red", "blue", "green"),
            required: false
        )

        validations.add(
            "name",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Provided name is empty!"
        )
    }
}

