//
//  DetailCollectionViewSectionDataModels.swift
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
    var header: String
    var title: String
    var address: String
    var files: [String]
}

struct DetailCollectionViewFirstSectionDataModel {
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
    var header: String
    var content: String
    var visitDate: String
    var creator: Creator
}

struct DetailCollectionViewSecondSectionDataModel {
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
struct ThirdSectionCellData {
    var header: String
    var latitude: Double
    var longitude: Double
    var longAddress: String
    var hashTags: [String]
}

struct DetailCollectionViewThirdSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewThirdSectionDataModel: SectionModelType {

    typealias Item = ThirdSectionCellData
    
    init(original: DetailCollectionViewThirdSectionDataModel, items: [ThirdSectionCellData]) {
        self = original
        self.items = items
    }
}

// MARK: - DetailCollectionViewForthSectionDataModel
struct DetailCollectionViewForthSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewForthSectionDataModel: SectionModelType {
    
    typealias Item = String
    
    init(original: DetailCollectionViewForthSectionDataModel, items: [String]) {
        self = original
        self.items = items
    }
}
