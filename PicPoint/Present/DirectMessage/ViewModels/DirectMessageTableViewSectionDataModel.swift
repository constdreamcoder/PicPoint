//
//  DirectMessageTableViewSectionDataModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import Foundation
import Differentiator

struct DirectMessageTableViewSectionDataModel {
  var header: String
  var items: [Item]
}

extension DirectMessageTableViewSectionDataModel: SectionModelType {
  typealias Item = ChatRoomMessage

   init(original: DirectMessageTableViewSectionDataModel, items: [Item]) {
    self = original
    self.items = items
  }
}
