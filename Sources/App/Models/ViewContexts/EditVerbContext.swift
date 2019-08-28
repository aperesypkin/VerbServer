//
//  EditVerbContext.swift
//  App
//
//  Created by Alexander Peresypkin on 27/08/2019.
//

import Vapor

struct EditVerbContext: Encodable {
    let title = "Редактировать глагол"
    let verb: Future<Verb>
}
