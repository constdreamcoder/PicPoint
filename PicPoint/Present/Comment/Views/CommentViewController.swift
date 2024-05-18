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

    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    let commentWritingSectionView = TextWritingSectionView()
    
    let bottomSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let nextButtonBottonConstraintsDefaultConstant: CGFloat = 0.0
    
    private lazy var baseViewTap: UITapGestureRecognizer = {
        let baseTap = UITapGestureRecognizer(target: self, action: nil)
        baseView.addGestureRecognizer(baseTap)
        baseView.isUserInteractionEnabled = true
        return baseTap
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
}

extension CommentViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "댓글"
    }
    
    func configureConstraints() {
        [
            baseView,
            noContentsWarningLabel
        ].forEach { view.addSubview($0) }
        
        baseView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noContentsWarningLabel.snp.makeConstraints {
            $0.centerX.equalTo(baseView)
            $0.centerY.equalTo(baseView).offset(-150.0)
        }
        
        [
            tableView,
            bottomSectionView,
            commentWritingSectionView
        ].forEach { baseView.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomSectionView.snp.top)
        }
        
        bottomSectionView.snp.makeConstraints {
            $0.height.equalTo(60.0)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        commentWritingSectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(nextButtonBottonConstraintsDefaultConstant)
        }
    }
    
    func configureUI() {
        noContentsWarningLabel.text = "댓글이 존재하지 않습니다."
    }
    
    func bind() {
        
        let textView = commentWritingSectionView.textView
        
        let commentDeleteEvent = Observable.zip(
            tableView.rx.itemDeleted,
            tableView.rx.modelDeleted(Comment.self)
        )
        
        let commentText = textView.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, commentText in
                if commentText == owner.commentWritingSectionView.textViewPlaceHolder {
                    return ""
                } else {
                    return commentText
                }
            }
        
        guard let refreshControl = tableView.refreshControl else { return }
        
        let input = CommentViewModel.Input(
            commentTextEvent: commentText,
            commentDidBeginEditing: textView.rx.didBeginEditing,
            commentDidEndEditing: textView.rx.didEndEditing, 
            sendButtonTap: commentWritingSectionView.sendButton.rx.tap,
            commentDeleteEvent: commentDeleteEvent,
            baseViewTap: baseViewTap.rx.event, 
            refreshControlValueChanged: refreshControl.rx.controlEvent(.valueChanged)
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.endRefreshTrigger
            .drive(with: self) { owner, _ in
                refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        output.commentList
            .drive(tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { row, element, cell in
                
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
        
        output.commentList
            .drive(with: self) { owner, commentList in
                owner.noContentsWarningLabel.isHidden = commentList.count > 0
            }
            .disposed(by: disposeBag)
        
        output.commentText
            .drive(with: self) { owner, commentText in
                let textVeiw = owner.commentWritingSectionView.textView
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
        
        output.sendButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.commentWritingSectionView.textView.text = nil
            }
            .disposed(by: disposeBag)
        
        output.commentSendingValid
            .drive(commentWritingSectionView.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.baseViewTapTrigger
            .drive(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard Control Methods
extension CommentViewController {
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            // 노치 디자인이 있는 경우 safe area를 계산
            if #available(iOS 13.0, *) {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let bottomInset = window?.safeAreaInsets.bottom ?? 0
                let adjustedKeyboardHeight = keyboardHeight - bottomInset
                commentWritingSectionView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-adjustedKeyboardHeight)
                }
            } else {
                commentWritingSectionView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardHeight)
                }
            }
            view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification){
        commentWritingSectionView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(nextButtonBottonConstraintsDefaultConstant)
        }
        view.layoutIfNeeded()
    }
}
