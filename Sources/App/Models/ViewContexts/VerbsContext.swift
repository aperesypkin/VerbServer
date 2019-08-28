//
//  VerbsContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct VerbsContext: Encodable {
    let title: String
    let verbs: Future<[Verb]>
}
