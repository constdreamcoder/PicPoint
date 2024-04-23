//
//  PreviewViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import SnapKit

final class PreviewViewController: BaseViewController {
    
    let photoImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var dismissButton = DismissButton()
    
    var photoImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.clipsToBounds = true
    }
}

extension PreviewViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "사진"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
    }
    
    func configureConstraints() {
        view.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        photoImageView.image = photoImage
    }
    
    func bind() {
        
    }
}
