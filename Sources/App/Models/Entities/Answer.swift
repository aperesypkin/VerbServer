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

extension Answer: Migration {}

// MARK: - Content

extension Answer: Content {}

// MARK: - Parameter

extension Answer: Parameter {}
