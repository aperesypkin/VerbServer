//
//  TaskType.swift
//  App
//
//  Created by Alexander Peresypkin on 06/04/2019.
//

import Vapor
import FluentPostgreSQL

enum TaskType: String, PostgreSQLEnum {
    case threeForms
    case translate
}

// MARK: - PostgreSQLMigration

extension TaskType: PostgreSQLMigration {}
