//
//  Token.swift
//  App
//
//  Created by Alexander Peresypkin on 16/03/2019.
//

import Vapor
import FluentSQLite
import Authentication

final class Token {
    var id: UUID?
    var token: String
    var userID: User.ID
    
    var user: Parent<Token, User> {
        return parent(\.userID)
    }
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token: SQLiteUUIDModel {}

extension Token: Migration {}

extension Token: Content {}

extension Token: Authentication.Token {
    typealias UserType = User
    
    static let tokenKey: WritableKeyPath<Token, String> = \.token
    static let userIDKey: WritableKeyPath<Token, User.ID> = \.userID
}
