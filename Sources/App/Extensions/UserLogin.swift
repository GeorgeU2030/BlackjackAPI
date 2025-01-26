import Vapor

extension User {
    struct Login: Content {
        var email: String
        var password: String
    }
}