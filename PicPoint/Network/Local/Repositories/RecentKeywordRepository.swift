//
//  RecentKeywordRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class RecentKeywordRepository: RepositoryType {

    static let shared = RecentKeywordRepository()
    
    private init() { }
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", RecentKeywordRepository.realm.configuration.fileURL!)
    }
    
    func read(_ object: RecentKeyword.Type) -> RealmSwift.Results<RecentKeyword> {
        return RecentKeywordRepository.realm.objects(object)
    }
    
    func write(_ object: RecentKeyword) {
        do {
            try RecentKeywordRepository.realm.write {
                RecentKeywordRepository.realm.add(object)
                print("새로운 채팅방이 추가 되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: RecentKeyword) {
        do {
            try RecentKeywordRepository.realm.write {
                RecentKeywordRepository.realm.delete(object)
                print("해당 채팅방이 정상적으로 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAll() {
        do {
            try RecentKeywordRepository.realm.write {
                RecentKeywordRepository.realm.deleteAll()
                print("최근 챝가 모두 삭제되었습니다.")
            }
        } catch {
            print(error)
        }
    }
}

