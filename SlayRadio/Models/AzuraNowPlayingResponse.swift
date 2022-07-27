//
//  AzuraNowPlayingResponse.swift
//  SlayRadio
//
//  Created by Wisse Hes on 25/07/2022.
//

import Foundation

// MARK: - AzuraNowPlayingResponse
struct AzuraNowPlayingResponse: Codable {
    let station: AzuraNowPlayingStation
    let listeners: AzuraNowPlayingListeners
//    let live: AzuraNowPlayingLive
    let nowPlaying: AzuraNowPlaying
    let playingNext: AzuraNowPlayingPlayingNext
    let songHistory: [AzuraNowPlaying]
    let isOnline: Bool
//    let cache: JSONNull?

    enum CodingKeys: String, CodingKey {
        case station, listeners
//        case live
        case nowPlaying = "now_playing"
        case playingNext = "playing_next"
        case songHistory = "song_history"
        case isOnline = "is_online"
//        case cache
    }
}

// MARK: - AzuraNowPlayingListeners
struct AzuraNowPlayingListeners: Codable {
    let total, unique, current: Int
}

// MARK: - AzuraNowPlaying
struct AzuraNowPlaying: Codable {
    let shID, playedAt, duration: Int
    let playlist, streamer: String
    let isRequest: Bool
    let song: AzuraNowPlayingSong
    let elapsed, remaining: Int?

    enum CodingKeys: String, CodingKey {
        case shID = "sh_id"
        case playedAt = "played_at"
        case duration, playlist, streamer
        case isRequest = "is_request"
        case song, elapsed, remaining
    }
}

// MARK: - AzuraNowPlayingSong
struct AzuraNowPlayingSong: Codable {
    let id, text, artist, title: String
    let album, genre, isrc, lyrics: String
    let art: String
//    let customFields: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, text, artist, title, album, genre, isrc, lyrics, art
//        case customFields = "custom_fields"
    }
}

// MARK: - AzuraNowPlayingPlayingNext
struct AzuraNowPlayingPlayingNext: Codable {
    let cuedAt, playedAt, duration: Int
    let playlist: String
    let isRequest: Bool
    let song: AzuraNowPlayingSong

    enum CodingKeys: String, CodingKey {
        case cuedAt = "cued_at"
        case playedAt = "played_at"
        case duration, playlist
        case isRequest = "is_request"
        case song
    }
}

// MARK: - AzuraNowPlayingStation
struct AzuraNowPlayingStation: Codable {
    let id: Int
    let name, shortcode, stationDescription, frontend: String
    let backend: String
    let listenURL: String
    let url: String
    let publicPlayerURL: String
    let playlistPlsURL: String
    let playlistM3UURL: String
    let isPublic: Bool
    let mounts: [AzuraNowPlayingMount]
//    let remotes: [JSONAny]
    let hlsEnabled: Bool
//    let hlsURL: JSONNull?
    let hlsListeners: Int

    enum CodingKeys: String, CodingKey {
        case id, name, shortcode
        case stationDescription = "description"
        case frontend, backend
        case listenURL = "listen_url"
        case url
        case publicPlayerURL = "public_player_url"
        case playlistPlsURL = "playlist_pls_url"
        case playlistM3UURL = "playlist_m3u_url"
        case isPublic = "is_public"
        case mounts
//        case remotes
        case hlsEnabled = "hls_enabled"
//        case hlsURL = "hls_url"
        case hlsListeners = "hls_listeners"
    }
}

// MARK: - AzuraNowPlayingMount
struct AzuraNowPlayingMount: Codable {
    let id: Int
    let name: String
    let url: String
    let bitrate: Int
    let format: String
    let listeners: AzuraNowPlayingListeners
    let path: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, url, bitrate, format, listeners, path
        case isDefault = "is_default"
    }
}
