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

	func download(index: PageIndex) -> AnyPublisher<[Show], Error>

}

struct ShowsDownloader {

	let network: NetworkSession

}

extension ShowsDownloader: ShowsDownloading {

	func download(index: PageIndex) -> AnyPublisher<[Show], Error> {
		let url = URL(string: "https://api.tvmaze.com/shows?page=\(index)")!
		return network.session.dataTaskPublisher(for: url)
			.map(\.data)
			.decode(type: [Show].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}

}
