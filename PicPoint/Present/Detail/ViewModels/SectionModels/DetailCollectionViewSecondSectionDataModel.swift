//
//  DetailCollectionViewSecondSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/13/24.
//

import Foundation
import Differentiator

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

struct SecondSectionCellData {
    var header: String
    var content: String
    var visitDate: String
    var creator: Creator
}
