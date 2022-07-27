//
//  ContentView.swift
//  SlayRadio
//
//  Created by Wisse Hes on 24/07/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var azura = NowPlayingManager()
    
    var body: some View {
        TabView {
            PlayerView()
                .tabItem {
                    Label("Player", systemImage: "radio")
                }
            
            RecentlyPlayedView()
                .tabItem {
                    Label("Recently Played", systemImage: "music.note.list")
                }
            
            RequestSongView()
                .tabItem {
                    Label("Request Songs", systemImage: "questionmark.circle")
                }
        }.environmentObject(azura)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
