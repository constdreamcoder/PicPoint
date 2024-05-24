//
//  RealmRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class ChatRoomRepository {
    
    static let shared = ChatRoomRepository()
    
    private let realm: Realm
    
    private init() {
        self.realm = try! Realm()
    }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return realm.objects(object)
    }
    
    func write<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
                print("새로운 채팅방이 추가 되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
                print("해당 채팅방이 정상적으로 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
                print("최근 챝가 모두 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
}
