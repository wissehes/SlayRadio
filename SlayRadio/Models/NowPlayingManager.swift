//
//  NowPlayingManager.swift
//  SlayRadio
//
//  Created by Wisse Hes on 25/07/2022.
//

import Foundation
import Starscream
import Alamofire
import MediaPlayer

class NowPlayingManager: ObservableObject, WebSocketDelegate {
    
    @Published var nowPlaying: AzuraNowPlaying?
    @Published var songHistory: [AzuraNowPlaying] = []

    @Published var socket: WebSocket
    
    init() {
        print("Initiating ws...")
        
        let request = URLRequest(url: Config.ws_url)
        socket = WebSocket(request: request)
        
        socket.delegate = self
        socket.connect()
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            print("🌐 WebSocket is connected!")
            print(headers)
        case .disconnected(_, _):
            print("🚫 WebSocket disconnected")
        case .text(let string):
//            print("String received: \(string)")
            decodeJsonAndUpdate(string)
        case .binary(_):
            break;
        case .pong(_):
            break;
        case .ping(_):
            break;
        case .error(let error):
            print("Websocket error occured: \(String(describing: error))")
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break;
        }
    }
    
    func decodeJsonAndUpdate(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            let decoded = try JSONDecoder().decode(AzuraNowPlayingResponse.self, from: data)
            DispatchQueue.main.async {
                self.nowPlaying = decoded.nowPlaying
                self.songHistory = decoded.songHistory
                self.updateNowplaying(decoded.nowPlaying)
            }
            print(decoded.nowPlaying.song.title)
            
        } catch(let err) {
            print(err)
        }
    }
    
    func updateNowplaying(_ data: AzuraNowPlaying) {
        if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo {
            nowPlayingInfo[MPMediaItemPropertyTitle] = data.song.title
            nowPlayingInfo[MPMediaItemPropertyArtist] = data.song.artist
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            // Update the image after the song/artist data
            // so that appears as fast as possible and does not have to
            // wait for the image to download
            self.updateImage(data)
        }
    }
    
    func updateImage(_ data: AzuraNowPlaying) {
        if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo {
            AF.request(data.song.art).responseData { response in
                switch response.result {
                    
                case .success(let data):
                    if let image = UIImage(data: data) {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                        }
                    }
                    
                case .failure(_):
                    if let image = UIImage(systemName: "music.note") {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                            return image
                        }
                    }
                    
                }
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }
    }
    
    func wsMsgtoData(message: URLSessionWebSocketTask.Message) -> Data? {
        switch message {
        case .data(let data):
            return data
        case .string(let string):
            return string.data(using: .utf8)
        @unknown default:
            print("No data")
            return nil
        }
    }
    
    
}
