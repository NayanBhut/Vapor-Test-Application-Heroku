import Fluent

struct UsersTableAdd: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("Users")
//            .id()
            .field("name", .string, .required)
            .field("age", .string, .required)
            .field("username", .string, .required)
            .field("id",.int8,.required)
            .field("email",.string,.required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("Users").delete()
    }
}

struct UsersTable_Name_ABC: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("Users")
            .field("first_Name", .string)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("Users")
            .deleteField("first_Name")
            .delete()
    }
}
