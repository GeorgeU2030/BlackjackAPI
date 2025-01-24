import Vapor
import Fluent
import FluentMongoDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // database configuration
    try app.databases.use(.mongo(connectionString: Environment.get("DATABASE_URL") ?? "mongodb://default_url"), as: .mongo)
    
    // jwt configuration
    let secret = Environment.get("SECRET") ?? "secretString"
    await app.jwt.keys.add(hmac: HMACKey(stringLiteral: secret), digestAlgorithm: .sha256)
    
    // add migrations

    // run migrations
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}
