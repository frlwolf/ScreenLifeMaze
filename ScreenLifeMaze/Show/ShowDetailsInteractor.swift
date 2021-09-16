//  
//  ShowDetailsInteractor.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

protocol ShowDetailsUseCase {

	func loadContent()

}

final class ShowDetailsInteractor {

	let index: Show.Index
	let downloader: ShowDetailsDownloading
	let adapter: ShowDetailsStateAdapter

	init(index: Show.Index, downloader: ShowDetailsDownloading, adapter: ShowDetailsStateAdapter) {
		self.index = index
		self.downloader = downloader
		self.adapter = adapter
	}

}

extension ShowDetailsInteractor: ShowDetailsUseCase {

	func loadContent() {
		let publisher = downloader.download(index: index)
			.handleEvents(receiveOutput: { [weak self] show in
				self?.loadEpisodes(of: show)
			})
			.eraseToAnyPublisher()
		adapter.didLoad(show: publisher)
	}

	private func loadEpisodes(of show: Show) {
		adapter.didLoad(episodes: downloader.episodes(show: show))
	}

}
