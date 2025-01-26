import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {

    // functions to define routes
    func boot(routes: RoutesBuilder) throws {
       
        let groupedRoutes = routes.grouped("auth")
        
        groupedRoutes.post("register", use: register)
        groupedRoutes.post("login", use: login)
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
    
    // function for login a user
    @Sendable
    func login(req: Request) async throws -> [String: String] {
            // Decode the user credentials from the JSON request body
            let loginData = try req.content.decode(User.Login.self)
            
            try User.Login.validate(content: req)
    
            // Search for the user by email
            guard let user = try await User.query(on: req.db)
                .filter(\.$email == loginData.email)
                .first() else {
                throw Abort(.unauthorized, reason: "User not found")
            }
    
            // Verify the password
            guard try user.verify(password: loginData.password) else {
                throw Abort(.unauthorized, reason: "Invalid credentials")
            }
    
            // Create the payload for the JWT
            let payload = Payload(
                subject: SubjectClaim(value: user.email),
                expiration: .init(value: .distantFuture) // Define the expiration as needed
            )
    
            // Sign the JWT
            let token = try await req.jwt.sign(payload)
    
            // Return the token in the response
            return ["token": token]
    }
    
}