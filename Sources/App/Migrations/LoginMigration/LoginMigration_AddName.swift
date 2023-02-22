//
//  LoginMigration_AddName.swift
//  
//
//  Created by Nayan Bhut on 8/13/22.
//

import Fluent
import PostgresNIO

extension UsersData {
    struct LoginMigration_AddName: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .field("first_Name", .string, .required, .sql(.default("Your default value")))
                .field("last_Name", .string, .required, .sql(.default("Your default value")))
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema("UsersDataTable")
                .deleteField("first_Name")
                .deleteField("last_Name")
                .update()
        }
    }
    
    struct LoginMigration_AddFirstName: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .field("first_Name", .string, .required, .sql(.default("Your default value")))
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .deleteField("first_Name")
                .delete()
        }
    }
    
    struct LoginMigration_AddLastName: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .field("last_Name", .string, .required, .sql(.default("Your default value")))
                .update()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema("UsersDataTable")
                .deleteField("last_Name")
                .delete()
        }
    }
}
