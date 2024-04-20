//
//  CommentViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class CommentViewController: BaseViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        return tableView
    }()
    
    let commentWritingSectionView = CommentWritingSectionView()
    
    private let viewModel: CommentViewModel?
    
    init(commentViewModel: CommentViewModel) {
        self.viewModel = commentViewModel
        
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

extension CommentViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "댓글"
    }
    
    func configureConstraints() {
        [
            tableView,
            commentWritingSectionView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(commentWritingSectionView.snp.top)
        }
        
        commentWritingSectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        let textView = commentWritingSectionView.commentTextView
        
        
        let input = CommentViewModel.Input(
            commentTextEvent: textView.rx.text.orEmpty,
            commentDidBeginEditing: textView.rx.didBeginEditing,
            commentDidEndEditing: textView.rx.didEndEditing, 
            sendButtonTap: commentWritingSectionView.sendButton.rx.tap
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.commentList
            .drive(tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { item, element, cell in
                
                if let profileImage = element.creator.profileImage, !profileImage.isEmpty {
                    let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
                    let placeholderImage = UIImage(systemName: "person.circle")
                    cell.commentView.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
                }
                
                cell.commentView.userNicknameLabel.text = element.creator.nick
                cell.commentView.subTitleLabel.text = element.content
                cell.commentView.agoLabel.text = element.createdAt.timeAgoToDisplay
            }
            .disposed(by: disposeBag)
        
        output.commentText
            .drive(with: self) { owner, commentText in
                let textVeiw = owner.commentWritingSectionView.commentTextView
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
                if textView.text == owner.commentWritingSectionView.textViewPlaceHolder
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
                    textView.text = owner.commentWritingSectionView.textViewPlaceHolder
                    textView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
    }
}
