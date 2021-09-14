//  
//  ShowsViewModel.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import Foundation
import Combine

final class ShowsViewModel {

	@Published(initialValue: [])
	var shows: [Show]

	init(observing state: ShowsState) {
		state.persistent
			.map { persistentState in
				switch persistentState {
				case .empty:
					return []
				case .partiallyLoaded(let shows):
					return shows
				case .fullyLoaded(let shows):
					return shows
				}
			}
			.receive(on: DispatchQueue.main)
			.assign(to: &$shows)
	}

}
