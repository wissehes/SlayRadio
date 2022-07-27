//
//  RecentlyPlayedView.swift
//  SlayRadio
//
//  Created by Wisse Hes on 25/07/2022.
//

import SwiftUI

struct RecentlyPlayedView: View {
    @EnvironmentObject var azura: NowPlayingManager

    var body: some View {
        NavigationView {
            List(azura.songHistory, id: \.shID) { item in
                HStack {
                    image(url: URL(string: item.song.art))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        Text(item.song.title)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                        
                        Text(item.song.artist)
                            .font(.subheadline)
                        
                        Text("\(Date(timeIntervalSince1970: TimeInterval(item.playedAt)), format: .relative(presentation: .numeric, unitsStyle: .wide))")
                    }
                }
            }.navigationTitle("Recently Played")
        }
    }
    
    func itemView(_ item: AzuraNowPlaying) {
        
    }
    
    func image(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure(_):
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFill()
                
            case .empty:
                ProgressView()
                
            @unknown default:
                ProgressView()
            }
        }
    }
}

struct RecentlyPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayedView()
    }
}
