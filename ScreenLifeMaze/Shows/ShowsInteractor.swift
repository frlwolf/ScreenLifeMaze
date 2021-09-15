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

	let stateAdapter: ShowsStateAdapting
	let provider: ShowsProviding

	init(provider: ShowsProviding, stateAdapter: ShowsStateAdapting) {
		self.stateAdapter = stateAdapter
		self.provider = provider
	}

}

extension ShowsInteractor: ShowsUseCase {

	func startLoadingContent() {
		let publisher = provider.showsPublisher()
			.mapError { _ in ShowsLoadingError.some }
			.eraseToAnyPublisher()
		stateAdapter.didLoad(showsPublisher: publisher)
	}

	func loadNext() {
		stateAdapter.willLoadMore()
		provider.nextPage()
	}

}
