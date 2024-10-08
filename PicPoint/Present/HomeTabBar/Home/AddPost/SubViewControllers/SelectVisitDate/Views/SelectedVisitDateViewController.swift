//
//  SelectedVisitDateViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectedVisitDateViewController: BaseBottomViewViewController {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        return datePicker
    }()
    
    private let viewModel: SelectVisitDateViewModel?
    
    init(
        selectVisitDateViewModel: SelectVisitDateViewModel?
    ) {
        self.viewModel = selectVisitDateViewModel
        
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

extension SelectedVisitDateViewController {
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
        
        let input = SelectVisitDateViewModel.Input(
            datePickerDateChanged: datePicker.rx.date.changed
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.visitDate
            .drive(datePicker.rx.date)
            .disposed(by: disposeBag)
    }
}
