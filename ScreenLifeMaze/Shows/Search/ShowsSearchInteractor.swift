//  
//  ShowsSearchInteractor.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

protocol ShowsSearchUseCase {

	func search(term: String)

}

final class ShowsSearchInteractor {

	let adapter: ShowsSearchStateAdapting
	let downloader: ShowsDownloading

	init(adapter: ShowsSearchStateAdapting, downloader: ShowsDownloading) {
		self.adapter = adapter
		self.downloader = downloader
	}

}

extension ShowsSearchInteractor: ShowsSearchUseCase {

	func search(term: String) {
		let publisher = downloader.search(query: term)
			.catch { error -> Just<[Show]> in
				print(error)
				return Just([])
			}
			.eraseToAnyPublisher()
		adapter.didSearch(results: publisher)
	}

}
