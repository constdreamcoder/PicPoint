//
//  FollowViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowViewController: BaseViewController {
  
    let menuSegmentControl: UnderlineSegmentedControl = {
        let segmentControl = UnderlineSegmentedControl(items: ["팔로워", "팔로잉"])
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ],
        for: .normal
        )
        segmentControl.setTitleTextAttributes(
          [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
          ],
          for: .selected
        )
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    lazy var followContentsPageVC: FollowContentsPageViewController = {
        let pageVC = FollowContentsPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageVC.delegate = self
        pageVC.dataSource = self
        return pageVC
    }()
       
    
    private let viewModel = FollowViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension FollowViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            menuSegmentControl,
            followContentsPageVC.view
        ].forEach { view.addSubview($0) }
        
        menuSegmentControl.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50.0)
        }
        
        followContentsPageVC.view.snp.makeConstraints {
            $0.top.equalTo(menuSegmentControl.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let input = FollowViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        menuSegmentControl.rx.selectedSegmentIndex
            .bind(with: self) { owner, selectedIndex in
                owner.followContentsPageVC.currentPage = selectedIndex
            }
            .disposed(by: disposeBag)
    }
}

extension FollowViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = followContentsPageVC.dataViewControllers.firstIndex(of: viewController)
        else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return followContentsPageVC.dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let index = followContentsPageVC.dataViewControllers.firstIndex(of: viewController)
        else { return nil }
        let nextIndex = index + 1
        if nextIndex == followContentsPageVC.dataViewControllers.count {
            return nil
        }
        return followContentsPageVC.dataViewControllers[nextIndex]
    }
}

extension FollowViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = followContentsPageVC.dataViewControllers.firstIndex(of: viewController)
        else { return }
        
        followContentsPageVC.currentPage = index
        menuSegmentControl.selectedSegmentIndex = index
    }
}
