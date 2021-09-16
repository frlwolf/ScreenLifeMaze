//  
//  ShowsState.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation
import Combine

protocol ShowsStateAdapting {

	func didLoad(showsPublisher: AnyPublisher<[Show.Index], Error>)

	func willLoadMore()

}

final class ShowsState {

	enum Persistent {
		case empty
		case partiallyLoaded([Show.Index])
		case fullyLoaded([Show.Index])
	}

	enum Transient {
		case none
		case loading
		case receive(chunk: [Show.Index])
	}

	let persistent = CurrentValueSubject<Persistent, Never>(.empty)
	let transient = CurrentValueSubject<Transient, Never>(.none)

	private var cancellables = [AnyCancellable]()

}

extension ShowsState: ShowsStateAdapting {

	func didLoad(showsPublisher: AnyPublisher<[Show.Index], Error>) {
		showsPublisher
			.sink(receiveCompletion: { [transient, persistent] completion in
				print("Did receive completion")
				transient.send(.none)
				guard case .finished = completion, case .partiallyLoaded(let shows) = persistent.value else {
					return // Unexpected end error handling
				}
				persistent.send(.fullyLoaded(shows))
			}, receiveValue: { [transient, persistent] chunk in
				
				print("Did load \(chunk.count) items")
				
				transient.send(.receive(chunk: chunk))
				if case let .partiallyLoaded(loadedSoFar) = persistent.value {
					persistent.send(.partiallyLoaded(loadedSoFar + chunk))
				} else {
					persistent.send(.partiallyLoaded(chunk))
				}
				transient.send(.none)
			})
			.store(in: &cancellables)
	}

	func willLoadMore() {
		transient.send(ShowsState.Transient.loading)
	}

}
