//  
//  ShowsDownloader.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation
import Combine

typealias PageIndex = Int

protocol ShowsDownloading {

	func download(index: PageIndex) -> AnyPublisher<[Show.Index], Error>

	func search(query: String) -> AnyPublisher<[Show.Index], Error>

}

struct ShowsDownloader {

	let network: NetworkSession

}

extension ShowsDownloader: ShowsDownloading {

	func download(index: PageIndex) -> AnyPublisher<[Show.Index], Error> {
		let url = URL(string: "https://api.tvmaze.com/shows?page=\(index)")!
		return network.session.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: [Show.Index].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

	func search(query: String) -> AnyPublisher<[Show.Index], Error> {
		let url = URL(string: "https://api.tvmaze.com/search/shows?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
		return network.session.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: [Show.SearchResult].self, decoder: JSONDecoder())
			.map { $0.map(\.show) }
			.eraseToAnyPublisher()
	}

}
