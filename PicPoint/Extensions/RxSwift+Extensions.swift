//
//  RxSwift+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

extension RxSwift.Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewDidAppear(_:)))
            .map { $0.first as? Bool ?? false }
    }
}
