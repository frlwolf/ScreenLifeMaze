//  
//  ShowDetailsViewModel.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

final class ShowDetailsViewModel {

	@Published(initialValue: nil)
	var show: Show?

	@Published(initialValue: [])
	var episodes: [Episode]

	init(observing state: ShowDetailsState) {
		state.persistent
			.compactMap { persistent -> Show? in
				switch persistent {
				case .loaded(let show):
					return show
				default:
					return nil
				}
			}
			.receive(on: DispatchQueue.main)
			.assign(to: &$show)

		state.persistent
			.map { persistent in
				guard case .loadedEpisodes(_, let episodes) = persistent else {
					return []
				}
				return episodes
			}
			.receive(on: DispatchQueue.main)
			.assign(to: &$episodes)
	}

}

extension ShowDetailsViewModel: EpisodesContaining { }
