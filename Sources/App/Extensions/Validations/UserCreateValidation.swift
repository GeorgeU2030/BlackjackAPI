import Vapor

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("email", as: String.self, is: .email, required: true)
        validations.add("password", as: String.self, is: .count(7...), required: true)
        validations.add("avatar", as: String.self, is: .url, required: true)
        validations.add("confirmPassword", as: String.self, is: .count(7...), required: true)
    }
}

extension User.Create {
    func validatePasswords() throws {
        if password != confirmPassword {
            throw Abort(.badRequest, reason: "Passwords do not match.")
        }
    }
}

