//
//  AppUrl.swift
//  AssignmentDemoTest
//
//  Created by akash dhomne on 14/06/23.
//

import UIKit

struct Domain {
    static let dev = "https://randomuser.me/api/"
}
extension Domain {
    static func baseUrl() -> String {
        return Domain.dev
    }
}

struct APIEndpoint {
    static let users         = "users?page=1&per_page=12"
}

enum HTTPHeaderField: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
}

enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}

enum MultipartType: String {
    case image = "Image"
    case csv = "CSV"
}

enum MimeType: String {
    case image = "image/png"
    case csvText = "text/csv"
}

enum UploadType: String {
    case avatar
    case file
}
