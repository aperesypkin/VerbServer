//
//  Task.swift
//  App
//
//  Created by Alexander Peresypkin on 12/03/2019.
//

import Vapor
import FluentSQLite

final class Task: Codable {
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
