//
//  User.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import FluentSQLite
import Authentication

final class User {
    var id: Int?
    var username: String
    var password: String
    
    var tokens: Children<User, Token> {
        return children(\.userID)
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension User: SQLiteModel {}

extension User: Migration {}

extension User: Content {}

extension User: Parameter {}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}

extension User: PasswordAuthenticatable {
    static let usernameKey: WritableKeyPath<User, String> = \.username
    static let passwordKey: WritableKeyPath<User, String> = \.password
}

extension User: SessionAuthenticatable {}

struct AdminUser: Migration {
    typealias Database = SQLiteDatabase
    
    static func prepare(on conn: SQLiteConnection) -> Future<Void> {
        let password = try? BCrypt.hash("123456")
        guard let hashedPassword = password else { fatalError("Failed to create admin user") }
        let user = User(username: "admin", password: hashedPassword)
        return user.save(on: conn).transform(to: ())
    }
    
    static func revert(on conn: SQLiteConnection) -> Future<Void> {
        return .done(on: conn)
    }
}
