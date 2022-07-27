//
//  RadioPlayer.swift
//  SlayRadio
//
//  Created by Wisse Hes on 25/07/2022.
//

import Foundation
import AudioStreaming
import MediaPlayer

class RadioPlayer: ObservableObject, AudioPlayerDelegate {
    var azura: NowPlayingManager?
    @Published var state: AudioPlayerState
    @Published var player: AudioPlayer
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
        state = .stopped
        player = .init()
        player.delegate = self
    }
    
    func setup(azura: NowPlayingManager) {
        self.azura = azura
    }
    
    func audioPlayerDidStartPlaying(player: AudioPlayer, with entryId: AudioEntryId) {
        state = .playing
        print("buffering...")
        
        if MPNowPlayingInfoCenter.default().nowPlayingInfo != nil {
            return;
        }
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "SlayRadio"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Loading..."

        if let image = UIImage(systemName: "music.note") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func audioPlayerDidFinishBuffering(player: AudioPlayer, with entryId: AudioEntryId) {
        state = .playing
        print("playing...")

    }
    
    func audioPlayerStateChanged(player: AudioPlayer, with newState: AudioPlayerState, previous: AudioPlayerState) {
//        self.player = player
        self.state = newState
    }
    
    func audioPlayerDidFinishPlaying(player: AudioPlayer, entryId: AudioEntryId, stopReason: AudioPlayerStopReason, progress: Double, duration: Double) {
        state = .stopped
    }
    
    func audioPlayerUnexpectedError(player: AudioPlayer, error: AudioPlayerError) {
        state = .stopped
    }
    
    func audioPlayerDidCancel(player: AudioPlayer, queuedItems: [AudioEntryId]) {
        state = .stopped
    }
    
    func audioPlayerDidReadMetadata(player: AudioPlayer, metadata: [String : String]) {
        print(metadata)
    }
    
}
