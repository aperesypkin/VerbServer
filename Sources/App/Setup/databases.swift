//
//  databases.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentPostgreSQL

public func databases(config: inout DatabasesConfig, env: inout Environment) throws {
    
    let databasePort = env == .testing ? 5433 : 5432
    let pgConfig = PostgreSQLDatabaseConfig(hostname: Environment.get("DATABASE_HOSTNAME") ?? "localhost",
                                            port: databasePort,
                                            username: Environment.get("DATABASE_USER") ?? "postgres",
                                            database: Environment.get("DATABASE_DB") ?? "verb_server",
                                            password: Environment.get("DATABASE_PASSWORD") ?? "123456")
    
    let database = PostgreSQLDatabase(config: pgConfig)
    
    config.add(database: database, as: .psql)
}
