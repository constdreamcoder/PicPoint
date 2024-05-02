//
//  ProfileCollectionViewSectionDataModels.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import Foundation
import Differentiator

// MARK: - ProfileCollectionViewFirstSectionDataModel
//struct FirstSectionCellData {
//    var header: String
//    var title: String
//    var address: String
//    var files: [String]
//}

struct ProfileCollectionViewFirstSectionDataModel {
    var items: [Item]
}

extension ProfileCollectionViewFirstSectionDataModel: SectionModelType {
    typealias Item = String
    
    init(original: ProfileCollectionViewFirstSectionDataModel, items: [String]) {
        self = original
        self.items = items
    }
}

// MARK: - ProfileCollectionViewSecondSectionDataModel
struct ProfileCollectionViewSecondSectionDataModel {
    var items: [Item]
}

extension ProfileCollectionViewSecondSectionDataModel: SectionModelType {
    typealias Item = String
    
    init(original: ProfileCollectionViewSecondSectionDataModel, items: [String]) {
        self = original
        self.items = items
    }
}
