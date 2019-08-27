//
//  Language.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import FluentPostgreSQL

enum Language: String, PostgreSQLEnum {
    case russian
    case english
}

// MARK: - PostgreSQLMigration

extension Language: PostgreSQLMigration {}

