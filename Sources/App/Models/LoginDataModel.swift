//
//  LoginDataModel.swift
//  
//
//  Created by Nayan Bhut on 5/14/22.
//

import Fluent
import Vapor
import Foundation

final class UsersData: Model, Content, Authenticatable {
    static let schema = "UsersDataTable"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "password") var password: String
    @Field(key: "token") var token: String?
    @Field(key: "loginType") var loginType: String
    @Timestamp(key: "createdDate", on: .create) var createdDate: Date?
    @Timestamp(key: "updatedDate", on: .update) var updatedDate: Date?
    @Field(key: "isVerified") var isVerified: Bool?
    @Field(key: "first_Name") var first_Name: String
    @Field(key: "last_Name") var last_Name: String
    
    init() { }
    
    init(id: UUID? = nil, first_Name:String = "", last_name:String = "", email: String, password: String, token: String? = nil, loginType: String, createdDate: Date? = nil, updatedDate: Date? = nil, isVerified: Bool = false) {
        self.id = id
        self.first_Name = first_Name
        self.last_Name = last_name
        self.email = email
        self.password = password
        self.token = token
        self.loginType = loginType
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.isVerified = isVerified
    }
}

extension UsersData: Validatable {
    static func validations(_ validations: inout Validations) {
        // Validations go here.
        validations.add(
            "first_Name",
            as: String.self,
            is: .count(3...10),
            customFailureDescription: "Please enter valid first Name"
        )
        
        validations.add(
            "last_Name",
            as: String.self,
            is: .count(3...10),
            customFailureDescription: "Please enter valid last Name"
        )
        
        validations.add(
            "email",
            as: String.self,
            is: .email,
            customFailureDescription: "Please enter valid email"
        )
        
        validations.add(
            "password",
            as: String.self,
            is: .count(3...) && .ascii,
            customFailureDescription: "Password is invalid!"
        )
        validations.add(
            "loginType",
            as: String.self,
            is: !.empty && .in(["facebook","google","email"]),
            customFailureDescription: "Please enter valid logintype"
        )
    }
}


final class OTPModel: Model, Content {
    static let schema = "OTPTable"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "otp") var otp: Int
    @Field(key: "userID") var userID: UUID
    @Timestamp(key: "createdDate", on: .create) var createdDate: Date?
    
    init() { }
    
    init(id: UUID? = nil, otp: Int, createdDate: Date? = nil, userID: UUID) {
        self.id = id
        self.otp = otp
        self.createdDate = createdDate
        self.userID = userID
    }
}

struct ResponseModel<T:Content>: Content {
    var data: T?
    var status: Bool
    var message: String?
}

struct UserResponseModel: Content {
    var id: UUID?
    var email: String?
    var token: String?
    var loginType: String?
    var otp: String?
    var first_Name: String?
    var last_Name: String?
}

struct RequestLogin: Content {
    var email: String
    var password: String
}

struct RequestOTPVerify: Content {
    var email: String?
    var otp: String?
}

struct CreateOrder: Content {
    var customer_id: String?
    var quantity: String?
    var product_id: String?
}

struct OrderResponse: Content {
    var orderId: String?
}
