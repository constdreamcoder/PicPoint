//
//  HomeViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    let leftBarButtonItemLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동작구"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .black
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: addPostButtonWidth / 2)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        button.layer.cornerRadius = addPostButtonWidth / 2
        return button
    }()
    
    private let addPostButtonWidth: CGFloat = 44.0
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func makeActionSheet(title: String? = nil, message: String? = nil, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let confirmButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
            handler()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(confirmButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}

extension HomeViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonItemLabel)
        
        let rightBarButtonItemImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonItemImage, style: .plain, target: self, action: nil)
    }
    
    func configureConstraints() {
        [
            collectionView,
            addPostButton
        ].forEach { view.addSubview($0) }
       
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addPostButton.snp.makeConstraints {
            $0.size.equalTo(addPostButtonWidth)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        let deletePostTap = PublishSubject<String>()
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        
        let input = HomeViewModel.Input(
            viewDidLoadTrigger: Observable<Void>.just(()),
            rightBarButtonItemTapped: rightBarButtonItem.rx.tap, 
            addButtonTap: addPostButton.rx.tap, 
            deletePostTap: deletePostTap,
            postTap: collectionView.rx.modelSelected(PostLikeType.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { [weak self] item, element, cell in
                guard let self else { return }
                
                cell.homeViewModel = viewModel
                cell.bind(element)
                
                cell.updatePostData(element)
            }
            .disposed(by: disposeBag)
        
        output.postTapTrigger
            .drive(with: self) { owner, post in
                if let post {
                    let detailVM = DetailViewModel(post: post)
                    detailVM.delegate = owner.viewModel
                    let detailVC = DetailViewController(detailViewModel: detailVM)
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
      
        output.addButtonTapTrigger
            .drive(with: self) { owner, _ in
                let addPostViewModel = AddPostViewModel()
                addPostViewModel.delegate = owner.viewModel
                let addPostVC = AddPostViewController(addPostViewModel: addPostViewModel)
                let addPostNav = UINavigationController(rootViewController: addPostVC)
                addPostNav.modalPresentationStyle = .fullScreen
                owner.present(addPostNav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.otherOptionsButtonTapTrigger
            .drive(with: self) { owner, postId in
                owner.makeActionSheet() {
                    deletePostTap.onNext(postId)
                }
            }
            .disposed(by: disposeBag)
        
        output.postId
            .drive(with: self) { owner, postId in
                let commentVM = CommentViewModel(postId: postId)
                commentVM.delegate = owner.viewModel
                let commentVC = CommentViewController(commentViewModel: commentVM)
                let commentNav = UINavigationController(rootViewController: commentVC)
                owner.present(commentNav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.moveToOtherProfileTrigger
            .drive(with: self) { owner, fetchOtherProfileModel in
                let profileVM = ProfileViewModel(fetchOtherProfileModel)
                let profileVC = ProfileViewController(profileViewModel: profileVM)
                owner.navigationController?.pushViewController(profileVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
       
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
