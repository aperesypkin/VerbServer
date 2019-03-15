//
//  Task.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import FluentSQLite

final class Task {
    var id: Int?
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension Task: SQLiteModel {}

extension Task: Migration {}

extension Task: Content {}

extension Task: Parameter {}

extension Task: Validatable {
    static func validations() throws -> Validations<Task> {
        var validations = Validations(Task.self)
        try validations.add(\.title, .count(3...))
        try validations.add(\.description, .count(5...))
        return validations
    }
}
