//
//  AddPostCollectionViewSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import Differentiator

struct AddPostCollectionViewSectionDataModel {
    var items: [AddPostCollectionViewCellType]
}

extension AddPostCollectionViewSectionDataModel: SectionModelType {
    typealias Item = AddPostCollectionViewCellType

    init(original: AddPostCollectionViewSectionDataModel, items: [AddPostCollectionViewCellType]) {
        self = original
        self.items = items
    }
}
