//
//  DetailCollectionViewFirstSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/13/24.
//

import Foundation
import Differentiator

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

struct FirstSectionCellData {
    var header: String
    var title: String
    var address: String
    var files: [String]
}
