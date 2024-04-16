//
//  RxSwift+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController{
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
}
