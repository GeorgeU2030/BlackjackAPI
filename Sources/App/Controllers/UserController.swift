import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("players")
        usersRoute.get("top", use: getTopUsers)
        usersRoute.put("update", ":userID", use: updateBalance)
    }
    
    @Sendable
    func getTopUsers(req: Request) throws -> EventLoopFuture<[UserResponse]> {
        return User.query(on: req.db)
            .sort(\.$maxBalance, .descending)
            .sort(\.$wins, .descending)
            .sort(\.$blackjacks, .descending)
            .limit(10)
            .all()
            .map { users in
                users.map { user in UserResponse(
                                    id: user.id,
                                    name: user.name,
                                    email: user.email,
                                    maxBalance: user.maxBalance,
                                    currentBalance: user.currentBalance,
                                    wins: user.wins,
                                    blackjacks: user.blackjacks,
                                    avatar: user.avatar
                            ) }
            }
    }
    
    @Sendable
    func updateBalance(req: Request) throws -> EventLoopFuture<UserResponse> {
        let userID = try req.parameters.require("userID", as: UUID.self)
        print(userID)
        let updateData = try req.content.decode(UpdateBalanceRequest.self)
            
        return User.find(userID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
            user.currentBalance = updateData.currentBalance
            if user.currentBalance > user.maxBalance {
                user.maxBalance = user.currentBalance
            }
            user.wins += updateData.wins
            user.blackjacks += updateData.blackjacks
                return user.save(on: req.db).map {
                    UserResponse(
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        maxBalance: user.maxBalance,
                        currentBalance: user.currentBalance,
                        wins: user.wins,
                        blackjacks: user.blackjacks,
                        avatar: user.avatar
                    )
                }
            }
    }
    
}