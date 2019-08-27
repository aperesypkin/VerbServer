//
//  TaskVerbPivot.swift
//  App
//
//  Created by Alexander Peresypkin on 06/04/2019.
//

import Vapor
import FluentPostgreSQL

final class TaskVerbPivot: PostgreSQLUUIDPivot, ModifiablePivot {
    
    // MARK: - Fields
    
    var id: UUID?
    var taskID: Task.ID
    var verbID: Verb.ID
    
    // MARK: - PostgreSQLUUIDPivot
    
    typealias Left = Task
    typealias Right = Verb
    
    static var leftIDKey: LeftIDKey = \.taskID
    static var rightIDKey: RightIDKey = \.verbID
    
    // MARK: - ModifiablePivot
    
    init(_ task: Task, _ verb: Verb) throws {
        taskID = try task.requireID()
        verbID = try verb.requireID()
    }
}

// MARK: - Migration

extension TaskVerbPivot: Migration {}
