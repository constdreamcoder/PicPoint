//
//  BirthDaySignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthDaySignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let birthdayText: Observable<String>
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let birthdayValid: Driver<Bool>
        let signUpButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let birthdayValidation = PublishRelay<Bool>()
        let startSignUpTrigger = PublishSubject<Void>()
        
        input.bottomButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.birthdayText)
            .subscribe(with: self) { owner, birthdayText in
                if birthdayText == "" || owner.isValidBirthday(birthdayText) {
                    SignUpStorage.shared.birthday = birthdayText.trimmingCharacters(in: .whitespacesAndNewlines)
                    birthdayValidation.accept(true)
                    startSignUpTrigger.onNext(())
                } else {
                    birthdayValidation.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        let signUpButtonTapTrigger = startSignUpTrigger
            .map { _ in
                return SignUpBody(
                    email: SignUpStorage.shared.email,
                    password: SignUpStorage.shared.password,
                    nick: SignUpStorage.shared.nickname,
                    phoneNum: SignUpStorage.shared.phoneNumber,
                    birthDay: SignUpStorage.shared.birthday
                )
            }
            .flatMap { signUpBody in
                UserManager.signUp(body: signUpBody)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<SignUpModel>.never()
                    }
            }
            .map { signUpModel in
                SignUpStorage.shared.clearAll()
                return ()
            }
            
        return Output(
            birthdayValid: birthdayValidation.asDriver(onErrorJustReturn: false),
            signUpButtonTapTrigger: signUpButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}

extension BirthDaySignUpViewModel {
    func isValidBirthday(_ birthday: String) -> Bool {
        // 생년월일은 8자리인지 체크
        guard birthday.count == 8 else {
            return false
        }

        // 모든 문자가 숫자여야 함
        guard let _ = Int(birthday) else {
            return false
        }

        // 연도, 월, 일이 각각 유효한 범위에 있는지 확인
        let year = Int(birthday.prefix(4)) ?? 0
        let month = Int(birthday.dropFirst(4).prefix(2)) ?? 0
        let day = Int(birthday.dropFirst(6)) ?? 0

        guard (1900...9999).contains(year) else {
            return false
        }
        guard (1...12).contains(month) else {
            return false
        }
        guard (1...31).contains(day) else {
            return false
        }

        // 월과 일이 유효한 조합인지 확인
        if month == 2 {
            // 2월은 윤년 확인
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
            if isLeapYear {
                return (1...29).contains(day)
            } else {
                return (1...28).contains(day)
            }
        } else if [4, 6, 9, 11].contains(month) {
            return (1...30).contains(day)
        } else {
            return true
        }
    }
}
