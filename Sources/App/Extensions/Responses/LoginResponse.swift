import Vapor

struct LoginResponse: Content {
    var user: UserResponse
    var token: String
}

struct UpdateBalanceRequest: Content {
    var currentBalance: Int
    var wins: Int
    var blackjacks: Int
}

struct UserResponse: Content {
    var id: UUID?
    var name: String
    var email: String
    var maxBalance: Int
    var currentBalance: Int
    var wins: Int
    var blackjacks: Int
    var avatar: String
}