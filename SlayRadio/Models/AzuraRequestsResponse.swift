//
//  AzuraRequestsResponse.swift
//  SlayRadio
//
//  Created by Wisse Hes on 27/07/2022.
//

import Foundation

typealias AzuraRequestsItems = [AzuraRequestsItem]

// MARK: - AzuraRequestsItem
struct AzuraRequestsItem: Codable {
    let requestID, requestURL: String
    let song: AzuraRequestsSong

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case requestURL = "request_url"
        case song
    }
}

// MARK: - AzuraRequestsSong
struct AzuraRequestsSong: Codable {
    let id, text, artist, title: String
    let album: String
    let genre: String
    let isrc: String
    let lyrics: String
    let art: String
//    let customFields: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, text, artist, title, album, genre, isrc, lyrics, art
//        case customFields = "custom_fields"
    }
}

// MARK: - AzuraRequestResponse

struct AzuraRequestResponse: Codable {
    let message: String
    let success: Bool
}
