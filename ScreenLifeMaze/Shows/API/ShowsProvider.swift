//  
//  ShowsProvider.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation
import Combine

protocol ShowsProviding {

	func showsPublisher() -> AnyPublisher<[Show.Index], ShowsProvidingError>

	func nextPage()

}

enum ShowsProvidingError: Error {
	case eof
	case urlError(URLError)
	case genericError(Error)
}

final class ShowsProvider {

	let downloader: ShowsDownloading

	private var cancellables = [AnyCancellable]()
	private let showsRelay = PassthroughSubject<[Show.Index], ShowsProvidingError>()

	private var wasEndReached: Bool = false
	private var currentPage: Int = 0

	init(downloader: ShowsDownloading) {
		self.downloader = downloader
	}

}

extension ShowsProvider: ShowsProviding {
	
	func showsPublisher() -> AnyPublisher<[Show.Index], ShowsProvidingError> {
		defer { downloadCurrentPage() }
		return showsRelay.eraseToAnyPublisher()
	}

	func nextPage() {
		if wasEndReached {
			return
		}
		currentPage += 1
		downloadCurrentPage()
	}
	
	private func downloadCurrentPage() {
		downloader.download(index: currentPage)
			.mapError { error -> ShowsProvidingError in
				if let urlError = error as? URLError {
					if urlError.errorCode == 404 {
						return .eof
					}
					return .urlError(urlError)
				}
				return .genericError(error)
			}
			.sink(
				receiveCompletion: { [weak self, showsRelay] completion in
					guard case .failure(let error) = completion else {
						return
					}
					if case .eof = error {
						self?.wasEndReached = true
					}
					showsRelay.send(completion: completion)
				},
				receiveValue: { [showsRelay] shows in
					showsRelay.send(shows)
				}
			)
			.store(in: &cancellables)
	}

}
