//
//  AddPostCollectionViewSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import Differentiator

struct AddPostCollectionViewSectionDataModel {
    var items: [AddPostCollectionVIewCellType]
}

extension AddPostCollectionViewSectionDataModel: SectionModelType {
    typealias Item = AddPostCollectionVIewCellType

    init(original: AddPostCollectionViewSectionDataModel, items: [AddPostCollectionVIewCellType]) {
        self = original
        self.items = items
    }
}
