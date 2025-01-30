import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("players")
        usersRoute.get("top", use: getTopUsers)
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
}