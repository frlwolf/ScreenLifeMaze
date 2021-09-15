//  
//  ShowsSearchState.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

protocol ShowsSearchStateAdapting {

	func didSearch(results: AnyPublisher<[Show], Never>)

}

final class ShowsSearchState {

	enum Persistent {
		case empty
		case resultsFound([Show])
	}

	enum Transient {
		case none
		case loading
	}

	let persistent = CurrentValueSubject<Persistent, Never>(.empty)
	let transient = CurrentValueSubject<Transient, Never>(.none)

	private var cancellables = [AnyCancellable]()

}

extension ShowsSearchState: ShowsSearchStateAdapting {

	func didSearch(results: AnyPublisher<[Show], Never>) {
		transient.send(.loading)
		results.sink { [persistent, transient] shows in
			transient.send(.none)
			if shows.count > 0 {
				persistent.send(.resultsFound(shows))
			} else {
				persistent.send(.empty)
			}
		}
		.store(in: &cancellables)
	}

}
