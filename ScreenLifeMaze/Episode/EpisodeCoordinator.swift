//  
//  EpisodeCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 19/09/21.
//

import Foundation

final class EpisodeCoordinator {

	let episode: Episode

	init(episode: Episode) {
		self.episode = episode
	}

	func start(navigable: Navigable) {
		let viewModel = EpisodeViewModel(episode: episode)
		let viewController = EpisodeViewController(viewModel: viewModel)

		navigable.navigateTo(view: viewController)
	}

}
