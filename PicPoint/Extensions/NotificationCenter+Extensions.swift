//
//  NotificationCenter+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/1/24.
//

import Foundation

extension Notification.Name {
    static let sendNewPost = Notification.Name("sendNewPost")
    static let sendDeletedMyPostId = Notification.Name("sendUpdatedPostList")
    static let sendNewLikedPost = Notification.Name("sendNewLikedPost")
    static let sendUnlikedPost = Notification.Name("sendUnlikedPost")
}
