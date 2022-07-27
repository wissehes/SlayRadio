//
//  Config.example.swift
//  SlayRadio
//
//  Created by Wisse Hes on 27/07/2022.
//

/**
 This is an example configuration file
 Rename the struct below to `Config`
 */

import Foundation

struct Config_Example {
    // This is the base URL of your AzuraCast instance
    static let azuracast_URL = "https://your-azuracast" // Make sure to NOT include a trailing slash (/)
    // This is the station shortcode you want to use
    // Make sure this is the shortcode, and not the number.
    static let station_shortcode = "radio"
    // Replace this URL with the url of your main stream
    static let main_stream: URL = URL(string: "https://your-azuracast/listen/radio/radio.mp3")!
    
    
    // No need to touch these :)
    static let azuracast_base = azuracast_URL
    
    // This generates the Websockets URL, by replacing `http` in the azuracast url
    // with `ws` and adds the websocket station. So `https://azuracast.instance`
    // would create `wss://azuracast.instance/api/live/nowplaying/<shortcode>`
    static var ws_url: URL {
        let wsurl = azuracast_URL.replacingOccurrences(of: "http", with: "ws")
        return URL(string: "\(wsurl)/api/live/nowplaying/\(station_shortcode)")!
    }
}
