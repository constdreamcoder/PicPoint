//
//  SectionModelWrapper.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
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
