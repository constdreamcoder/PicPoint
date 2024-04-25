//
//  TitleTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TitleTableViewCell: BaseTableViewCell {
    
    lazy var titleTextView: InnerTextViewContainerView = {
        let view = InnerTextViewContainerView()
        view.textView.text = titleTextViewPlaceHolder
        view.textView.textColor = .lightGray
        view.textView.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return view
    }()
    
    lazy var remainCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0/\(charactersLimit)"
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .lightGray
        label.textAlignment = .center
        
        return label
    }()
    
    private let titleTextViewPlaceHolder: String = "제목을 입력해주세요"

    private let charactersLimit = 35

    weak var addPostViewModel: AddPostViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    private func updateCountLabel(characterCount: Int) {
        remainCountLabel.text = "\(characterCount)/\(charactersLimit)"
        remainCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .black)
    }
}

extension TitleTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            titleTextView,
            remainCountLabel
        ].forEach { contentView.addSubview($0) }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        remainCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(4.0)
            $0.trailing.equalTo(titleTextView.textView).inset(8.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(4.0)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind(_ tableView: UITableView) {
        let textView = titleTextView.textView

        titleTextView.textView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if textView.text == owner.titleTextViewPlaceHolder
                    && textView.textColor == .lightGray {
                    textView.text = nil
                    textView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        titleTextView.textView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && textView.textColor == .black {
                    textView.text = owner.titleTextViewPlaceHolder
                    textView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
        titleTextView.textView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        titleTextView.textView.rx.text.orEmpty
            .bind(with: self) { owner, text in
                guard owner.titleTextViewPlaceHolder != text else { return }
                guard let addPostViewModel = owner.addPostViewModel else { return }
                addPostViewModel.titleTextRalay.accept(text)
            }
            .disposed(by: disposeBag)
        
        titleTextView.textView.rx.didChange
            .bind(with: self) { owner, _ in
                let size = owner.titleTextView.textView.bounds.size
                let newSize = tableView.sizeThatFits(
                    CGSize(
                        width: size.width,
                        height: CGFloat.greatestFiniteMagnitude
                    )
                )
                
                if size.height != newSize.height {
                    UIView.setAnimationsEnabled(false)
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }
            }
            .disposed(by: disposeBag)
        
    }
}

extension TitleTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= charactersLimit else { return false }
        updateCountLabel(characterCount: characterCount)
        
        return true
    }
}
