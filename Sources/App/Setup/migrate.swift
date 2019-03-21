//
//  migrate.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentSQLite

public func migrate(migrations: inout MigrationConfig) throws {
    
    migrations.add(model: Task.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Token.self, database: .sqlite)
    migrations.add(migration: AdminUser.self, database: .sqlite)
    
}
