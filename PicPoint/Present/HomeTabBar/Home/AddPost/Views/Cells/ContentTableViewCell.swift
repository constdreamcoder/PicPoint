//
//  ContentTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ContentTableViewCell: BaseTableViewCell {
    
    lazy var contentTextView: InnerTextViewContainerView = {
        let view = InnerTextViewContainerView()
        view.textView.text = contentTextViewPlaceHolder
        view.textView.textColor = .lightGray
        view.textView.font = .systemFont(ofSize: 18.0)
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
    
    private let contentTextViewPlaceHolder: String = """
                                                     나만의 사진 찍는 꿀팁에 대해서 공유해주세요!!
                                                     """

    private let charactersLimit = 800
    
    weak var addPostViewModel: AddPostViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
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

extension ContentTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            contentTextView,
            remainCountLabel
        ].forEach { contentView.addSubview($0) }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        remainCountLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(4.0)
            $0.trailing.equalTo(contentTextView.textView).inset(8.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(4.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind(_ tableView: UITableView) {
        let textView = contentTextView.textView

        contentTextView.textView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if textView.text == owner.contentTextViewPlaceHolder
                    && textView.textColor == .lightGray {
                    textView.text = nil
                    textView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.textView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && textView.textColor == .black {
                    textView.text = owner.contentTextViewPlaceHolder
                    textView.textColor = .lightGray
                    owner.updateCountLabel(characterCount: 0)
                }
            }
            .disposed(by: disposeBag)
        
        contentTextView.textView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        contentTextView.textView.rx.text.orEmpty
            .bind(with: self) { owner, text in
                guard owner.contentTextViewPlaceHolder != text else { return }
                guard let addPostViewModel = owner.addPostViewModel else { return }
                addPostViewModel.contentTextRalay.accept(text)
            }
            .disposed(by: disposeBag)
        
        contentTextView.textView.rx.didChange
            .bind(with: self) { owner, _ in
                let size = owner.contentTextView.textView.bounds.size
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

extension ContentTableViewCell: UITextViewDelegate {
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
