//
//  Task.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import FluentPostgreSQL

final class Task {
    
    // MARK: - Fields
    
    var id: Int?
    var title: String
    var description: String
    var type: TaskType
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(title: String, description: String, type: TaskType) {
        self.title = title
        self.description = description
        self.type = type
    }
}

// MARK: - PostgreSQLModel

extension Task: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var verbs: Siblings<Task, Verb, TaskVerbPivot> {
        return siblings()
    }
}

// MARK: - Migration

extension Task: Migration {}

// MARK: - Content

extension Task: Content {}

// MARK: - Parameter

extension Task: Parameter {}

// MARK: - Validatable

extension Task: Validatable {
    
    static func validations() throws -> Validations<Task> {
        var validations = Validations(Task.self)
        try validations.add(\.title, .count(3...30))
        try validations.add(\.description, .count(5...100))
        return validations
    }
}
