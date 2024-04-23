//
//  RecommendedVisitTimeViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecommendedVisitTimeViewController: BaseBottomViewViewController {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        return datePicker
    }()
    
    let viewModel: RecommendedVisitTimeViewModel?
    
    init(
        recommendedVisitTimeViewModel: RecommendedVisitTimeViewModel?
    ) {
        self.viewModel = recommendedVisitTimeViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension RecommendedVisitTimeViewController {
    override func configureNavigationBar() {
        super.configureNavigationBar()
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        bottomSheetView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func bind() {
        super.bind()
                
        let input = RecommendedVisitTimeViewModel.Input(
            datePickerDateChanged: datePicker.rx.date.changed
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
    }
}
