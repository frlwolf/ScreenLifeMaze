//  
//  ShowsInteractor.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

protocol ShowsUseCase {

	func startLoadingContent()

	func next()

}

final class ShowsInteractor {

	let stateAdapter: ShowsStateAdapter
	let provider: ShowsProviding

	init(provider: ShowsProviding, stateAdapter: ShowsStateAdapter) {
		self.stateAdapter = stateAdapter
		self.provider = provider
	}

}

extension ShowsInteractor: ShowsUseCase {

	func startLoadingContent() {
		let publisher = provider.showsPublisher()
		stateAdapter.didLoad(showsPublisher: publisher)
	}

	func next() {
		stateAdapter.willLoadMore()
		provider.nextPage()
	}

}
