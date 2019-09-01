//
//  Answer.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor
import FluentPostgreSQL

final class Answer {
    
    // MARK: - Fields
    
    var id: Int?
    var value: String
    var isRight: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var verbID: Verb.ID
    
    // MARK: - Initialization
    
    init(value: String, isRight: Bool, verbID: Verb.ID) {
        self.value = value
        self.isRight = isRight
        self.verbID = verbID
    }
}

// MARK: - PostgreSQLModel

extension Answer: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var verb: Parent<Answer, Verb> {
        return parent(\.verbID)
    }
}

// MARK: - Migration

extension Answer: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.verbID, to: \Verb.id, onDelete: .cascade)
        }
    }
}

// MARK: - Content

extension Answer: Content {}

// MARK: - Parameter

extension Answer: Parameter {}

// MARK: - Validatable

extension Answer: Validatable {
    
    static func validations() throws -> Validations<Answer> {
        var validations = Validations(Answer.self)
        try validations.add(\.value, .count(2...30))
        return validations
    }
}
