//  
//  ShowsSearchViewModel.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import Combine

final class ShowsSearchViewModel {

	@Published(initialValue: [])
	var shows: [Show.Index]

	init(observing state: ShowsSearchState) {
		state.persistent
			.map { persistent in
				switch persistent {
				case .resultsFound(let shows):
					return shows
				case .empty:
					return []
				}
			}
			.receive(on: DispatchQueue.main)
			.assign(to: &$shows)
	}

}

extension ShowsSearchViewModel: ShowsContaining { }
