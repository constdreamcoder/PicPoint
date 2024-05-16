//
//  DirectMessageViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DirectMessageViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(DirectMessageTableViewCell.self, forCellReuseIdentifier: DirectMessageTableViewCell.identifier)
        
        return tableView
    }()
    
    let chatWritingSectionView = CommentWritingSectionView("")
    
    private let viewModel = DirectMessageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }

}

extension DirectMessageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            tableView,
            chatWritingSectionView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatWritingSectionView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }

    func bind() {
        
        let textView = chatWritingSectionView.commentTextView
        
        let commentText = textView.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, commentText in
                if commentText == owner.chatWritingSectionView.textViewPlaceHolder {
                    return ""
                } else {
                    return commentText
                }
            }

        let input = DirectMessageViewModel.Input(
            commentTextEvent: commentText,
            didBeginEditing: textView.rx.didBeginEditing,
            didEndEditing: textView.rx.didEndEditing, 
            sendButtonTap: chatWritingSectionView.sendButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        Observable.just([1,2,3,4,45,5,5,3])
            .bind(to: tableView.rx.items(cellIdentifier: DirectMessageTableViewCell.identifier, cellType: DirectMessageTableViewCell.self)) { row, element, cell in
                
            }
            .disposed(by: disposeBag)
        
        output.commentText
            .drive(with: self) { owner, commentText in
                let textVeiw = owner.chatWritingSectionView.commentTextView
                let size = CGSize(
                    width: textVeiw.frame.size.width,
                    height: .infinity
                )
                let estimatedSize = textVeiw.sizeThatFits(size)
                
                guard textVeiw.contentSize.height < 100.0 else {
                    textVeiw.isScrollEnabled = true
                    return
                }
                
                textVeiw.isScrollEnabled = false
                textVeiw.constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.commentDidBeginEditingTrigger
            .drive(with: self) { owner, _ in
                if textView.text == owner.chatWritingSectionView.textViewPlaceHolder
                    && textView.textColor == .lightGray {
                    textView.text = nil
                    textView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        output.commentDidEndEditingTrigger
            .drive(with: self) { owner, _ in
                if textView.textColor == .black
                    && textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    textView.text = owner.chatWritingSectionView.textViewPlaceHolder
                    textView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
        output.commentSendingValid
            .drive(chatWritingSectionView.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.sendButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.chatWritingSectionView.commentTextView.text = nil
            }
            .disposed(by: disposeBag)
    }
    
}
