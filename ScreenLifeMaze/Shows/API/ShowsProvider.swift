//  
//  ShowsProvider.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation
import Combine

protocol ShowsProviding {

	func showsPublisher() -> AnyPublisher<[Show], Error>

	func nextPage()

}

final class ShowsProvider {

	let downloader: ShowsDownloading

	private var cancellables = [AnyCancellable]()
	private let showsRelay = PassthroughSubject<[Show], Error>()

	private var wasEndReached: Bool?
	private var currentPage: Int = 0

	init(downloader: ShowsDownloading) {
		self.downloader = downloader
	}

}

extension ShowsProvider: ShowsProviding {

	func showsPublisher() -> AnyPublisher<[Show], Error> {
		downloader.download(index: currentPage)
			.subscribe(showsRelay)
			.store(in: &cancellables)
		return showsRelay.eraseToAnyPublisher()
	}

	func nextPage() {
		currentPage += 1
		downloader.download(index: currentPage)
			.subscribe(showsRelay)
			.store(in: &cancellables)
	}

}
