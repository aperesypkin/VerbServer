//
//  migrate.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentPostgreSQL

public func migrate(migrations: inout MigrationConfig) throws {
    
    // MARK: - Enums
    
    migrations.add(migration: TaskType.self, database: .psql)
    migrations.add(migration: Language.self, database: .psql)
    
    // MARK: - Entities
    
    migrations.add(model: Task.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Token.self, database: .psql)
    migrations.add(model: Verb.self, database: .psql)
    migrations.add(model: Answer.self, database: .psql)
    
    // MARK: - Pivots
    
    migrations.add(model: TaskVerbPivot.self, database: .psql)
    
    // MARK: - Database data
    
    migrations.add(migration: AdminUser.self, database: .psql)
    
    // MARK: - Migrations
}
