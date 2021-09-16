//  
//  ShowDetailsState.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

protocol ShowDetailsStateAdapter {

	func didLoad(show: AnyPublisher<Show, Error>)

	func didLoad(episodes: AnyPublisher<[Episode], Error>)

}

final class ShowDetailsState {

	enum Persistent {
		case empty
		case loaded(Show)
		case loadedEpisodes(Show, [Episode])
	}

	enum Transient {
		case none
		case loading
	}

	let persistent = CurrentValueSubject<Persistent, Never>(.empty)
	let transient = CurrentValueSubject<Transient, Never>(.none)

	private var cancellables = [AnyCancellable]()

}

extension ShowDetailsState: ShowDetailsStateAdapter {

	func didLoad(show: AnyPublisher<Show, Error>) {
		transient.send(.loading)
		show.sink(receiveCompletion: { [transient] _ in
			transient.send(.none)
		}, receiveValue: { [transient, persistent] show in
			transient.send(.none)
			persistent.send(.loaded(show))
		}).store(in: &cancellables)
	}

	func didLoad(episodes: AnyPublisher<[Episode], Error>) {
		transient.send(.loading)
		episodes.sink(receiveCompletion: { [transient] _ in
			transient.send(.none)
		}, receiveValue: { [transient, persistent] episodes in
			transient.send(.none)
			guard case .loaded(let show) = persistent.value else { return }
			persistent.send(.loadedEpisodes(show, episodes))
		}).store(in: &cancellables)
	}

}
