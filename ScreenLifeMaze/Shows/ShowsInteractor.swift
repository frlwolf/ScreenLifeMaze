//  
//  ShowsInteractor.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation
import Combine

protocol ShowsUseCase {

	func startLoadingContent()

	func loadNext()

}

enum ShowsLoadingError: Error {
	case some
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
			.mapError { error -> ShowsLoadingError in
				print(error)
				return ShowsLoadingError.some
			}
			.eraseToAnyPublisher()
		stateAdapter.didLoad(showsPublisher: publisher)
	}

	func loadNext() {
		stateAdapter.willLoadMore()
		provider.nextPage()
	}

}
