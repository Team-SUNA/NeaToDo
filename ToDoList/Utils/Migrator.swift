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
        fetchData()
    }

    func updateSchema() {
        let config = Realm.Configuration(schemaVersion: 3)
//        { migration, oldSchemaVersion in
//            if oldSchemaVersion < 1 {
//                migration.enumerateObjects(ofType: Task.className()) {_, newObject in
//
//                }
//            }
//        }
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }

    func fetchData() {
        guard let dbRef = try? Realm() else { return }

        let results = dbRef.objects(Task.self)

        //Displaying results
//        self.cards = results.compactMap({ (card) -> Task? in
//            return card
//        })
    }

}
