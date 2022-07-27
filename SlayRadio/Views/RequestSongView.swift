//
//  RequestSongView.swift
//  SlayRadio
//
//  Created by Wisse Hes on 27/07/2022.
//

import SwiftUI
import Alamofire

struct RequestSongView: View {
//    @EnvironmentObject var azura: NowPlayingManager
    @State var requestItems: AzuraRequestsItems = []
    @State var searchText = ""
    
    @State var alertType: AlertType = .success
    @State var alertShowing = false
    
    func showAlert(_ type: AlertType) {
        self.alertType = type
        self.alertShowing = true
    }

    var body: some View {
        NavigationView {
            List(requestItems, id: \.requestID) { item in
                requestItemView(item)
            }
            .onAppear {
                if requestItems.count != 0 {
                    load()
                }
            }
            .alert(alertType.title, isPresented: $alertShowing) {
                Button("OK") {}
            } message: {
                Text(alertType.message)
            }
            .searchable(text: $searchText, prompt: "Search songs...") {
                ForEach(searchResults, id: \.requestID) { item in
                    requestItemView(item)
                }
            }
            .refreshable {
                do {
                    let url = URL(string: "\(Config.azuracast_base)/api/station/1/requests")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    
                    requestItems = try JSONDecoder().decode(AzuraRequestsItems.self, from: data).shuffled()
                } catch {
                    requestItems = []
                }
            }
            .navigationTitle("Request songs")
        }
    }
    
    func requestItemView(_ item: AzuraRequestsItem) -> some View {
        HStack {
            image(url: URL(string: item.song.art))
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(item.song.title)
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.bold)
                
                Text(item.song.artist)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button("Request!"){
                request(item)
            }.buttonStyle(.borderedProminent)
        }
    }
    
    func request(_ item: AzuraRequestsItem) {
        AF.request("\(Config.azuracast_base)\(item.requestURL)").responseDecodable(of: AzuraRequestResponse.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
                
                self.showAlert(data.success ? .success : .failed(data.message))

            case .failure(let err):
                print(err)
                self.showAlert(.failed(err.localizedDescription))
            }
        }
    }
    
    var searchResults: AzuraRequestsItems {
        if searchText.isEmpty {
            return requestItems
        } else {
            return requestItems.filter { $0.song.text.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func load() {
        AF.request("\(Config.azuracast_base)/api/station/1/requests").validate().responseDecodable(of: AzuraRequestsItems.self) { response in
            switch response.result {
                
            case .success(let items):
                self.requestItems = items.shuffled()
            case .failure(let err):
                print(err)
            }
        }
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
    
    enum AlertType {
        case success
        case failed(String)
    }
}

extension RequestSongView.AlertType {
    var title: String {
        switch self {
        case .success:
            return "Song Requested!"
        case .failed(_):
            return "Request Failed"
        }
    }
    var message: String {
        switch self {
        case .success:
            return "Your request was processed successfully and will play shortly!"
        case .failed(let err):
            return err
        }
    }
}

struct RequestSongView_Previews: PreviewProvider {
    static var previews: some View {
        RequestSongView()
    }
}
