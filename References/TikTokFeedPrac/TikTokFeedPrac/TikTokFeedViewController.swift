//
//  TikTokFeedViewController.swift
//  TikTokFeedPrac
//
//  Created by SUCHAN CHANG on 4/12/24.
//

import UIKit
import SnapKit

final class TikTokFeedViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self        
        
        collectionView.register(TikTokFeedCollectionViewCell.self, forCellWithReuseIdentifier: TikTokFeedCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let dataList: [UIImage] = [
        .init(systemName: "square.and.arrow.up")!,
        .init(systemName: "square.and.arrow.up.fill")!,
        .init(systemName: "square.and.arrow.up.circle")!,
        .init(systemName: "square.and.arrow.up.circle.fill")!,
        .init(systemName: "square.and.arrow.down")!,
        .init(systemName: "square.and.arrow.down.fill")!,
        .init(systemName: "square.and.arrow.up.on.square.fill")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        guard let navigationController else { return UICollectionViewLayout() }
        let navigationBarHeight = navigationController.navigationBar.frame.height
        print("navigationBarHeight", navigationBarHeight)
        let topSafeareInset = getSafeAreaInset().top
        print("SafeAreaInset", getSafeAreaInset())
        print("getStatusBarRect", getStatusBarRect())
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        print("dd", tabBarController?.tabBar.frame)
        print("tabBarHeight", tabBarHeight)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height - (topSafeareInset + navigationBarHeight + tabBarHeight))
        
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
                
        return layout
    }
    
    private func getSafeAreaInset() -> UIEdgeInsets {
        // connectedScenes에 접근하여 첫번째 scene 가져오기
        let connectedScene = UIApplication.shared.connectedScenes.first
        
        // UIWindowScene으로 캐스팅
        let windowScene = connectedScene as? UIWindowScene
        
        // 첫번째 window 가져오기
        let window = windowScene?.windows.first
        
        // safeAreaInset 획득
        let safeAreaInset = window?.safeAreaInsets ?? .zero
        return safeAreaInset
    }
    
    private func getStatusBarRect() -> CGRect {
        // connectedScenes에 접근하여 첫번째 scene 가져오기
        let connectedScene = UIApplication.shared.connectedScenes.first
        
        // UIWindowScene으로 캐스팅
        let windowScene = connectedScene as? UIWindowScene
        
        // 첫번째 window 가져오기
        let window = windowScene?.windows.first
        
        // safeAreaFrame 획득
        let safeAreaFrame = window?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
        return safeAreaFrame
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "테스트"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func configureConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension TikTokFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TikTokFeedCollectionViewCell.identifier, for: indexPath) as? TikTokFeedCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .brown
        }
        
        return cell
    }
}

