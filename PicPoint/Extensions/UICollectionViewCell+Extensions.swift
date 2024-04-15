//
//  UICollectionViewCell+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit

extension UICollectionViewCell: CellIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
