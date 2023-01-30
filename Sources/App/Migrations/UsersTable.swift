import Fluent

struct UsersTable: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("Users")
            .id()
            .field("email", .string, .required)
            .field("name", .string, .required)
            .field("username", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}
