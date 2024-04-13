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
        
        configureConstraints()
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let topSafeareInset = getSafeareInset().top
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height - (topSafeareInset + tabBarHeight))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 0
                
        return layout
    }
    
    private func getSafeareInset() -> UIEdgeInsets {
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
    
    private func configureConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
}

extension TikTokFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TikTokFeedCollectionViewCell.identifier, for: indexPath) as? TikTokFeedCollectionViewCell else { return UICollectionViewCell() }
        
        cell.testImageView.image = dataList[indexPath.item]
        
        return cell
    }
}

