//
//  Migrator.swift
//  ToDoList
//
//  Created by 김나연 on 2022/10/19.
//

import Foundation
import RealmSwift

class Migrator {
    init() {
        updateSchema()
    }

    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }

}
