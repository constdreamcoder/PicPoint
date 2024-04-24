//
//  UploadImagesBody.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import Foundation

struct UploadImagesBody {
    let keyName = "files"
    let files: [ImageFile]
}

struct ImageFile {
    let imageData: Data
    let name: String
    let mimeType: MemeType
    
    enum MemeType: String {
        case png = "image/png"
        case jpeg = "image/jpeg"
        case gif = "image/gif"
    }
}
