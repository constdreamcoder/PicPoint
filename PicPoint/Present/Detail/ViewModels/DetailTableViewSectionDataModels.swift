//
//  DetailTableViewSectionDataModels.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import Foundation
import Differentiator

struct SectionModelWrapper: SectionModelType {
    var items: [Item]
    
    init<S: SectionModelType>(_ sectionModel: S) {
        self.items = sectionModel.items
    }

    init(original: SectionModelWrapper, items: [Item]) {
        self.items = items
    }
}

extension SectionModelWrapper {
    typealias Item = Any
}

// MARK: - DetailCollectionViewFirstSectionDataModel
struct FirstSectionCellData {
    var title: String
    var files: [String]
}

struct DetailCollectionViewFirstSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewFirstSectionDataModel: SectionModelType {
    typealias Item = FirstSectionCellData
    
    init(original: DetailCollectionViewFirstSectionDataModel, items: [FirstSectionCellData]) {
        self = original
        self.items = items
    }
}

// MARK: - DetailCollectionViewSecondSectionDataModel
struct SecondSectionCellData {
    var content: String
    var createdAt: String
    var creator: Creator
}

struct DetailCollectionViewSecondSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewSecondSectionDataModel: SectionModelType {
    
    typealias Item = SecondSectionCellData
    
    init(original: DetailCollectionViewSecondSectionDataModel, items: [SecondSectionCellData]) {
        self = original
        self.items = items
    }
}


// MARK: - DetailCollectionViewThirdSectionDataModel
struct DetailCollectionViewThirdSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewThirdSectionDataModel: SectionModelType {
    
    typealias Item = String
    
    init(original: DetailCollectionViewThirdSectionDataModel, items: [String]) {
        self = original
        self.items = items
    }
}


