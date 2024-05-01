//
//  BaseBottomViewViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/23/24.
//

import UIKit
import SnapKit

class BaseBottomViewViewController: BaseViewController {
    
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        return view
    }()
    
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private var defaultHeight: CGFloat = UIScreen.main.bounds.height * 0.3
    
    private var topConstant: CGFloat = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
        configureOtherSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        let bottomSheetViewTop = (safeAreaHeight + bottomPadding) - defaultHeight

        bottomSheetView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(bottomSheetViewTop)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(safeAreaHeight + bottomPadding)
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

extension BaseBottomViewViewController {
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}

extension BaseBottomViewViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            dimmedView,
            bottomSheetView,
        ].forEach { view.addSubview($0) }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(topConstant)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .clear
        
        dimmedView.alpha = 0.0
    }
    
    func bind() {
    
    }
    
    func configureOtherSettings() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }
}
