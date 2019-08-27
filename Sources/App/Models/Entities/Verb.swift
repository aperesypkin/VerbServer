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
    var transcription: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    // MARK: - Initialization
    
    init(infinitive: String, transcription: String? = nil) {
        self.infinitive = infinitive
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
}

// MARK: - Migration

extension Verb: Migration {}

// MARK: - Content

extension Verb: Content {}

// MARK: - Parameter

extension Verb: Parameter {}
