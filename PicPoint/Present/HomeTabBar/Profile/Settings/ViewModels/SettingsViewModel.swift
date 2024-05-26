//
//  SettingsViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let logoutButtonTapped: ControlEvent<Void>
        let withdrawalButtonTapped: ControlEvent<Void>
        let logoutTrigger: PublishSubject<Void>
        let withdrawalTrigger: PublishSubject<Void>
        let donationDetailsCellTapped: PublishSubject<Void>
        let myChatRoomListCellTapped: PublishSubject<Void>
    }
    
    struct Output {
        let questionLogoutTrigger: Driver<Void>
        let questionWithdrawalTrigger: Driver<Void>
        let successTrigger: Driver<Void>
        let goToPaymentListVCTrigger: Driver<[ValidatePaymentModel]>
        let goToMyChatRoomsVCTrigger: Driver<[ChatRoom]>
    }
    
    func transform(input: Input) -> Output {
        let questionLogoutTrigger = PublishRelay<Void>()
        let questionWithdrawalTrigger = PublishRelay<Void>()
        let successTrigger = PublishRelay<Void>()
        
        let goToPaymentListVCTrigger = input.donationDetailsCellTapped
            .flatMap { _ in
                PaymentManager.fetchPaymentList()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<[ValidatePaymentModel]>.never()
                    }
            }
        
        let goToMyChatRoomsVCTrigger = input.myChatRoomListCellTapped
            .flatMap { _ in
                ChatManager.fetchMyChatRoomList()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<[Room]>.never()
                    }
            }
            .map { myChatRoomList in
                let updatedMyChatRoomList = myChatRoomList.map { chatRoom in
                    let participants = chatRoom.participants.map {
                        User(userId: $0.userId, nick: $0.nick, profileImage: $0.profileImage)
                    }

                    var lastChat: LastChatMessage?
                    if let lastMessage = chatRoom.lastChat {
                        let lastMessageSender = lastMessage.sender
                        let sender = User(
                            userId: lastMessageSender.userId,
                            nick: lastMessageSender.nick,
                            profileImage: lastMessageSender.profileImage
                        )
                        
                        lastChat = LastChatMessage(
                            chatId: lastMessage.chatId,
                            roomId: lastMessage.roomId,
                            content: lastMessage.content,
                            createdAt: lastMessage.createdAt,
                            sender: sender,
                            files: lastMessage.files
                        )
                    }
                    
                    return ChatRoom(
                        roomId: chatRoom.roomId,
                        createdAt: chatRoom.createdAt,
                        updatedAt: chatRoom.updatedAt,
                        participants: participants, 
                        lastChat: lastChat
                    )
                }
                ChatRoomRepository.shared.updateChatRoomList(updatedMyChatRoomList)
                ChatRoomRepository.shared.getLocationOfDefaultRealm()
                return updatedMyChatRoomList
            }
        
        input.logoutButtonTapped
            .bind { _ in
                questionLogoutTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.logoutTrigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { _ in
                UserDefaultsManager.clearAllData()
                successTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.withdrawalButtonTapped
            .bind { _ in
                questionWithdrawalTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.withdrawalTrigger
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { _ in
                UserManager.withdraw()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<WithdrawalModel>.never()
                    }
            }
            .subscribe(with: self) { owner, withdrawalModel in
                UserDefaultsManager.clearAllData()
                successTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            questionLogoutTrigger: questionLogoutTrigger.asDriver(onErrorJustReturn: ()),
            questionWithdrawalTrigger: questionWithdrawalTrigger.asDriver(onErrorJustReturn: ()),
            successTrigger: successTrigger.asDriver(onErrorJustReturn: ()),
            goToPaymentListVCTrigger: goToPaymentListVCTrigger.asDriver(onErrorJustReturn: []),
            goToMyChatRoomsVCTrigger: goToMyChatRoomsVCTrigger.asDriver(onErrorJustReturn: [])
        )
    }
}
