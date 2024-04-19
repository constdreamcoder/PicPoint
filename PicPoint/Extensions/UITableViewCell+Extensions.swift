//
//  UITableViewCell+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import UIKit
import RxSwift

extension UITableViewCell: CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
