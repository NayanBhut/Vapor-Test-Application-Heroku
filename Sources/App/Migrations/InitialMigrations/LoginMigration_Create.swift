//
//  LoginMigration.swift
//  
//
//  Created by Nayan Bhut on 5/14/22.
//

import Fluent
import PostgresNIO

extension UsersData {
    struct LoginMigration: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .id()
                .field("email", .string, .required)
                .field("password", .string, .required)
                .field("token", .string, .required)
                .field("loginType", .string, .required)
                .field("createdDate", .string, .required)
                .field("updatedDate", .string, .required)
                .field("isVerified", .bool)
                .field("first_Name", .string, .required)
                .field("last_Name", .string, .required)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("UsersDataTable").delete()
        }
    }
}

struct OTPMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("OTPTable")
            .id()
            .field("userID", .uuid, .required)
            .field("otp", .int, .required)
            .field("createdDate", .string, .required)
            .foreignKey("userID", references: UsersData.schema, .id, onDelete: .cascade)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("OTPTable").delete()
    }
}
