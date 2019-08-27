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
    var language: Language
    var transcription: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(infinitive: String, language: Language, transcription: String? = nil) {
        self.infinitive = infinitive
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

extension Verb: Migration {}

// MARK: - Content

extension Verb: Content {}

// MARK: - Parameter

extension Verb: Parameter {}
