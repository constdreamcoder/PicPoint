//
//  RepositoryType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    associatedtype T: Object
    
    var realm: Realm { get }
    
    func getLocationOfDefaultRealm()
    func read() -> Results<T>
    func write(_ object: T)
    func delete(_ object: T)
    func deleteAll()
}

extension RepositoryType {
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func read() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func write(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
                print("\(T.self) 객체가 추가되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func update(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
                print("\(T.self) 객체가 수정되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
                print("\(T.self) 객체가 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self))
                print("\(T.self) 객체가 모두 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
}
