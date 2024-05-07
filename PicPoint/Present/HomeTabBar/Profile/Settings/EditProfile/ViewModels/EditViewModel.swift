//
//  EditViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol EditViewModelDelegate: AnyObject {
    func sendUpdatedProfileInfos(_ myNewProfile: FetchMyProfileModel)
}

final class EditViewModel: ViewModelType {
    
    let profileImageSubject = BehaviorSubject<Data>(value: Data())
    let myProfileRelay = BehaviorRelay<FetchMyProfileModel?>(value: nil)

    var disposeBag = DisposeBag()
    
    weak var delegate: EditViewModelDelegate?

    struct Input {
        let leftBarButtonItemTap: ControlEvent<Void>
        let editButtonObservable: Observable<(ControlProperty<String>.Element, ControlProperty<String>.Element, ControlProperty<String>.Element)>
        let profileImageTap: ControlEvent<UITapGestureRecognizer>
        let editButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let leftBarButtonItemTapTrigger: Driver<Void>
        let myProfile: Driver<FetchMyProfileModel?>
        let editButtonValid: Driver<Bool>
        let profileImageTapTrigger: Driver<Void>
        let editButtonTapTrigger: Driver<Void>
    }
    
    init(myProfile: FetchMyProfileModel) {
        Observable.just(myProfile)
            .subscribe(with: self) { owner, myProfile in
                owner.myProfileRelay.accept(myProfile)
            }
            .disposed(by: disposeBag)
            
    }

    func transform(input: Input) -> Output {
        let editButtonValidation = BehaviorRelay<Bool>(value: false)
        let editButtonTapTrigger = PublishRelay<Void>()
        
        input.editButtonObservable
            .subscribe { nicknameText, phoneNumText, birthDayText in
                if !nicknameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && !phoneNumText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && !birthDayText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    editButtonValidation.accept(true)
                } else {
                    editButtonValidation.accept(false)
                }
            }
            .disposed(by: disposeBag)
    
        input.editButtonTap
            .withLatestFrom(input.editButtonObservable)
            .withLatestFrom(profileImageSubject) { textDatas, profileImage in
                return (textDatas.0, textDatas.1, textDatas.2, profileImage)
            }
            .map { nicknameText, phoneNumText, birthdayText, profileImage in
                return EditMyProfileBody(
                    nick: nicknameText,
                    phoneNum: phoneNumText,
                    birthDay: birthdayText,
                    profileImage: ImageFile(
                        imageData: profileImage,
                        name: "profileImage\(Int.random(in: 1...1000))",
                        mimeType: .png)
                )
            }
            .flatMap {
                ProfileManager.editMyProfile(body: $0)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<FetchMyProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, newProfileModel in
                owner.delegate?.sendUpdatedProfileInfos(newProfileModel)
                editButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
            
        return Output(
            leftBarButtonItemTapTrigger: input.leftBarButtonItemTap.asDriver(),
            myProfile: myProfileRelay.asDriver(),
            editButtonValid: editButtonValidation.asDriver(), 
            profileImageTapTrigger: input.profileImageTap.map { _ in () }.asDriver(onErrorJustReturn: ()), 
            editButtonTapTrigger: editButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}

