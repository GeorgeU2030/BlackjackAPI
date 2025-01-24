import Vapor
import Fluent
import FluentMongoDriver

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("maxBalance", .int, .required)
            .field("currentBalance", .int, .required)
            .field("wins", .int, .required)
            .field("blackjacks", .int, .required)
            .field("avatar", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}