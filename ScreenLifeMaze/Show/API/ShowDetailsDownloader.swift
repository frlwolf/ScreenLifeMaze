//  
//  ShowDetailsDownloader.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

protocol ShowDetailsDownloading {

	func download(index: Show.Index) -> AnyPublisher<Show, Error>

	func episodes(show: Show) -> AnyPublisher<[Episode], Error>

}

struct ShowDetailsDownloader {

	let network: NetworkSession

}

extension ShowDetailsDownloader: ShowDetailsDownloading {

	func download(index: Show.Index) -> AnyPublisher<Show, Error> {
		let url = URL(string: "https://api.tvmaze.com/shows/\(index.id)")!
		return network.session.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: Show.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

	func episodes(show: Show) -> AnyPublisher<[Episode], Error> {
		let url = URL(string: "https://api.tvmaze.com/shows/\(show.id)/episodes")!
		return network.session.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: [Episode].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

}
