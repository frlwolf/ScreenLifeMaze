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
			.mapError { $0 as Error }
			.eraseToAnyPublisher()
		stateAdapter.didLoad(showsPublisher: publisher)
	}

	func loadNext() {
		stateAdapter.willLoadMore()
		provider.nextPage()
	}

}
