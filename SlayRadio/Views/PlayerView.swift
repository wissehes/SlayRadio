//
//  PlayerView.swift
//  SlayRadio
//
//  Created by Wisse Hes on 25/07/2022.
//

import SwiftUI
import AVFoundation
import AudioStreaming
import Alamofire
import MediaPlayer

struct PlayerView: View {
    @EnvironmentObject var azura: NowPlayingManager
    @StateObject var player: RadioPlayer = .init()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                nowPlayingView
                    .onAppear {
                        setupRemote()
                        azura.socket.connect()
                    }
                
                button
            }.navigationTitle("Slay Radio")
        }
    }
    
    @ViewBuilder
    var nowPlayingView: some View {
        if let nowPlaying = azura.nowPlaying {
            AsyncImage(url: URL(string: nowPlaying.song.art)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    Image(systemName: "exclamationmark.triangle")
                    
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 300, height: 300)
            .shadow(radius: 10)
            
            
            Text(nowPlaying.song.title)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(nowPlaying.song.artist)
                .font(.title2)
                .multilineTextAlignment(.center)
        } else {
            ProgressView()
        }
    }
    
    var button: some View {
        Button {
            withAnimation {
                toggle()
            }
        } label: {
            if player.state == .playing {
                Label("Stop", systemImage: "pause.circle")
                    .font(.largeTitle)
            } else {
                Label("Play", systemImage: "play.circle")
                    .font(.largeTitle)
            }
        }.labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
    }
    
    
    func toggle() {
        if player.state == .playing {
            stop()
        } else {
            play()
        }
    }
    
    func play() {
        do {
            print("AudioSession is active")
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setMode(.default)
        } catch let error as NSError {
            print("Couldn't set audio session to active: \(error.localizedDescription)")
        }
        
        player.player.play(url: Config.main_stream)
        
    }
    func stop() {
        player.player.stop()
    }
    
    func setupRemote() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            print("Play command called...")
            
            if self.player.state != .playing {
                self.play()
                return .success
            }
            
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { event in
            print("Pause command called...")
            
            if self.player.state == .playing {
                self.stop()
                return .success
            }
            
            return .commandFailed
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
