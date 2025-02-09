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
    app.migrations.add(CreateUser())
    // run migrations
    try await app.autoMigrate()
    
    // cors configuration
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    
    app.middleware.use(cors, at: .beginning)
    
    // register routes
    try routes(app)
}
