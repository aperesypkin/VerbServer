//
//  databases.swift
//  App
//
//  Created by Alexander Peresypkin on 13/03/2019.
//

import Vapor
import FluentSQLite

public func databases(config: inout DatabasesConfig) throws {
    
    let database = try SQLiteDatabase(storage: .memory)
    
    config.add(database: database, as: .sqlite)
    
}
