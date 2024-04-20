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
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        
        return collectionView
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
}

extension CommentViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "댓글"
    }
    
    func configureConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let input = CommentViewModel.Input()
     
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.commentList
            .drive(collectionView.rx.items(cellIdentifier: CommentCollectionViewCell.identifier, cellType: CommentCollectionViewCell.self)) { item, element, cell in
                
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
    }
}

extension CommentViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            
            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            
            return section
        }
    }
}

