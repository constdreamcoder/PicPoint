//
//  AddPostViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class AddPostViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(SelectImageTableViewCell.self, forCellReuseIdentifier: SelectImageTableViewCell.identifier)
        tableView.register(SelectLocationTableViewCell.self, forCellReuseIdentifier: SelectLocationTableViewCell.identifier)
        tableView.register(RecommendedVisitTimeTableViewCell.self, forCellReuseIdentifier: RecommendedVisitTimeTableViewCell.identifier)
        tableView.register(VisitDateTableViewCell.self, forCellReuseIdentifier: VisitDateTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        
        return tableView
    }()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AddPostCollectionViewSectionDataModel> { dataSource, tableView, indexPath, item in
        if item == .selectImageCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectImageTableViewCell.identifier, for: indexPath) as? SelectImageTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if item == .selectLocationCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationTableViewCell.identifier, for: indexPath) as? SelectLocationTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if item == .recommendedVisitTimeCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedVisitTimeTableViewCell.identifier, for: indexPath) as? RecommendedVisitTimeTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if item == .visitDateCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VisitDateTableViewCell.identifier, for: indexPath) as? VisitDateTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if item == .titleCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            
            cell.titleTextView.textView.rx.didChange
                .bind(with: self) { owner, _ in
                    let size = cell.titleTextView.textView.bounds.size
                    let newSize = tableView.sizeThatFits(
                        CGSize(
                            width: size.width,
                            height: CGFloat.greatestFiniteMagnitude
                        )
                    )
                    
                    if size.height != newSize.height {
                        UIView.setAnimationsEnabled(false)
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }                }
                .disposed(by: cell.disposeBag)
            
            return cell
        } else if item == .contentCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
            
            cell.contentTextView.textView.rx.didChange
                .bind(with: self) { owner, _ in
                    let size = cell.contentTextView.textView.bounds.size
                    let newSize = tableView.sizeThatFits(
                        CGSize(
                            width: size.width,
                            height: CGFloat.greatestFiniteMagnitude
                        )
                    )
                    
                    if size.height != newSize.height {
                        UIView.setAnimationsEnabled(false)
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }                }
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        return UITableViewCell()
    }
    
    private let viewModel = AddPostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
}

extension AddPostViewController {
    @objc func leftBarButtonItemTapped(_ barButtonItem: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension AddPostViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "새 게시글"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leftBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: nil)
    }
    
    func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        
        let input = AddPostViewModel.Input(
            rightBarButtonItemTap: rightBarButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.rightBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension AddPostViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment -> NSCollectionLayoutSection? in
            
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = true
            
            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            
            return section
        }
    }
    
}
