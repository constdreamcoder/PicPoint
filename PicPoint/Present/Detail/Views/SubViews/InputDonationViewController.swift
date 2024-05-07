//
//  InputDonationViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class InputDonationViewController: BaseBottomViewViewController {
    
    private let pickerView = UIPickerView()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.title = "금액 선택"
        button.configuration = buttonConfiguration
        return button
    }()
    
    private let donationAmountList = [100, 1000, 2000, 3000, 5000, 10_000, 15_000, 20_000]
    
    private let viewModel: InputDonationViewModel
    
    init(inputDonationViewModel: InputDonationViewModel) {
        self.viewModel = inputDonationViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension InputDonationViewController {
    override func configureConstraints() {
        super.configureConstraints()
        
    }
    
    override func configureUI() {
        super.configureUI()
        
        [
            selectButton,
            pickerView
        ].forEach { bottomSheetView.addSubview($0) }
 
        selectButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        pickerView.snp.makeConstraints {
            $0.top.equalTo(selectButton.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        let selectedAmountSubject = PublishSubject<Int>()
        
        let input = InputDonationViewModel.Input(
            selectAmount: selectedAmountSubject,
            selectButtonTap: selectButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        Observable.just(donationAmountList)
            .bind(to: pickerView.rx.itemTitles) { _, item in
                return "\(item)원"
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .bind(with: self) { owner, value in
                selectedAmountSubject.onNext(owner.donationAmountList[value.row])
            }
            .disposed(by: disposeBag)
        
        output.dismissInputDonationVCTrigger
            .drive(with: self) { onwer, _ in
                onwer.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
