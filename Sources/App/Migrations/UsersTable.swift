import Fluent

struct UsersTable: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("Users")
            .id()
            .field("email", .string, .required)
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}
