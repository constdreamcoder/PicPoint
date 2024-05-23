//
//  MyDirectMessageTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyDirectMessageTableViewCell: BaseTableViewCell {
    
    let chatBubbleImageView: ChatBubbleImageView = {
        let bubbleImageView = ChatBubbleImageView(frame: .zero)
        bubbleImageView.tintColor = .systemGray3
        return bubbleImageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let imageViewContainerView = UIStackView()
    
    let oneImageStackView = OneImageStackView()
    let twoImagesStackView = TwoImagesStackView()
    let threeImagesStackView = ThreeImagesStackView()
    let fourImagesStackView = FourImagesStackView()
    let fiveImagesStackView = FiveImagesStackView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 11:45"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    private let imageViewContainerViewWidth = UIScreen.main.bounds.width * 0.65
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        imageViewContainerView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        chatBubbleImageView.snp.removeConstraints()
        imageViewContainerView.snp.removeConstraints()
    }
    
    func updateCellDatas(_ chat: Chat) {
        if let content = chat.content, content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
            && chat.files.count >= 1 {
            chatBubbleImageView.snp.makeConstraints {
                $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
                $0.leading.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(90.0)
                $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.height.equalTo(0)
            }
        } else {
            chatBubbleImageView.snp.makeConstraints {
                $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
                $0.leading.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(90.0)
                $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
            }
        }
        contentLabel.text = chat.content
        dateLabel.text = chat.createdAt.getChattingDateString
        updateImageViewContainerView(chat.files)
    }
    
    private func updateImageViewContainerView(_ uploadedImageFiles: [String]) {
        switch uploadedImageFiles.count {
        case 1:
            oneImageStackView.updateImage(uploadedImageFiles)

            imageViewContainerView.addArrangedSubview(oneImageStackView)
            
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom).offset(4.0)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(imageViewContainerViewWidth)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(imageViewContainerViewWidth)
            }
        case 2:
            twoImagesStackView.updateImages(uploadedImageFiles)

            imageViewContainerView.addArrangedSubview(twoImagesStackView)
            
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom).offset(4.0)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(imageViewContainerViewWidth)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(imageViewContainerViewWidth / 2)
            }
        case 3:
            threeImagesStackView.updateImages(uploadedImageFiles)

            imageViewContainerView.addArrangedSubview(threeImagesStackView)
            
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom).offset(4.0)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(imageViewContainerViewWidth)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(imageViewContainerViewWidth / 3)
            }
        case 4:
            fourImagesStackView.updateImages(uploadedImageFiles)

            imageViewContainerView.addArrangedSubview(fourImagesStackView)
            
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom).offset(4.0)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(imageViewContainerViewWidth)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(imageViewContainerViewWidth / 2 * 2)
            }
        case 5:
            fiveImagesStackView.updateImages(uploadedImageFiles)

            imageViewContainerView.addArrangedSubview(fiveImagesStackView)
            
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom).offset(4.0)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(imageViewContainerViewWidth)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(imageViewContainerViewWidth / 3 * 2)
            }
        default:
            imageViewContainerView.snp.makeConstraints {
                $0.top.equalTo(chatBubbleImageView.snp.bottom)
                $0.trailing.equalTo(chatBubbleImageView)
                $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
                $0.width.equalTo(chatBubbleImageView)
            }
            
            imageViewContainerView.snp.makeConstraints {
                $0.height.equalTo(0.1)
            }
        }
    }
}

extension MyDirectMessageTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            chatBubbleImageView,
            imageViewContainerView,
            dateLabel
        ].forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(imageViewContainerView.snp.leading).offset(-4.0)
            $0.bottom.equalTo(imageViewContainerView)
            $0.leading.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(24.0)
        }
        
        chatBubbleImageView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalTo(chatBubbleImageView).inset(12.0)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    
}
