//
//  Verb.swift
//  App
//
//  Created by Alexander Peresypkin on 23/03/2019.
//

import Vapor
import FluentPostgreSQL

final class Verb {
    
    // MARK: - Fields
    
    var id: Int?
    var infinitive: String
    var pastSimple: String?
    var pastParticiple: String?
    var translation: String?
    var language: Language
    var transcription: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(infinitive: String,
         pastSimple: String? = nil,
         pastParticiple: String? = nil,
         translation: String? = nil,
         language: Language,
         transcription: String? = nil) {
        self.infinitive = infinitive
        self.pastSimple = pastSimple
        self.pastParticiple = pastParticiple
        self.translation = translation
        self.language = language
        self.transcription = transcription
    }
}

// MARK: - PostgreSQLModel

extension Verb: PostgreSQLModel {
    
    static var createdAtKey: TimestampKey? = \.createdAt
    static var updatedAtKey: TimestampKey? = \.updatedAt
    
    var tasks: Siblings<Verb, Task, TaskVerbPivot> {
        return siblings()
    }
    
    var answers: Children<Verb, Answer> {
        return children(\.verbID)
    }
}

// MARK: - Migration

extension Verb: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.infinitive)
        }
    }
}

// MARK: - Content

extension Verb: Content {}

// MARK: - Parameter

extension Verb: Parameter {}

// MARK: - Validatable

extension Verb: Validatable {
    
    static func validations() throws -> Validations<Verb> {
        var validations = Validations(Verb.self)
        try validations.add(\.infinitive, .count(2...30))
        return validations
    }
}
