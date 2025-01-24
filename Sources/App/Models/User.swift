import Vapor
import Fluent
import FluentMongoDriver

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "maxBalance")
    var maxBalance: Int
    
    @Field(key: "currentBalance")
    var currentBalance: Int
    
    @Field(key: "wins")
    var wins: Int
    
    @Field(key: "blackjacks")
    var blackjacks: Int
    
    @Field(key: "avatar")
    var avatar: String
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, password: String, maxBalance: Int = 0, currentBalance: Int = 100, wins: Int = 0, blackjacks: Int = 0, avatar: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.maxBalance = maxBalance
        self.currentBalance = currentBalance
        self.wins = wins
        self.blackjacks = blackjacks
        self.avatar = avatar
    }
}