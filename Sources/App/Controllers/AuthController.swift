import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {

    // functions to define routes
    func boot(routes: RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("register", use: register)
    }

    // function for register a user
    @Sendable 
    func register(req: Request) async throws -> User {
        // Validate the data received using `User.Create`
        try User.Create.validate(content: req)

        // Decode the request content to `User.Create`
        let userCreate = try req.content.decode(User.Create.self)

        try userCreate.validatePasswords()
        // Create a new instance of `User`
        let user = User(
            name: userCreate.name,
            email: userCreate.email,
            password: try Bcrypt.hash(userCreate.password),
            avatar: userCreate.avatar
        )
        
        // Save the user to the database
        try await user.save(on: req.db)

        // Return the user
        return user
    } 
}