//
//  DetailCollectionViewThirdSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/13/24.
//

import Foundation
import Differentiator

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

struct ThirdSectionCellData {
    var header: String
    var latitude: Double
    var longitude: Double
    var longAddress: String
    var hashTags: [String]
    var recommendedVisitTime: String
}
