//  
//  EpisodeViewModel.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 19/09/21.
//

import Foundation
import Combine

final class EpisodeViewModel {

	@Published
	var episode: Episode

	init(episode: Episode) {
		self.episode = episode
	}

}
