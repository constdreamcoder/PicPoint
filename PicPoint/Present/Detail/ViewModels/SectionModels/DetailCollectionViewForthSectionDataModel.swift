//
//  DetailCollectionViewForthSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/13/24.
//

import Foundation
import Differentiator

struct DetailCollectionViewForthSectionDataModel {
    var header: String
    var items: [Item]
}

extension DetailCollectionViewForthSectionDataModel: SectionModelType {
    
    typealias Item = Post
    
    init(original: DetailCollectionViewForthSectionDataModel, items: [Post]) {
        self = original
        self.items = items
    }
}
