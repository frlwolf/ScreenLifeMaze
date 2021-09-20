//  
//  ShowDetailsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

protocol ShowDetailsNavigating: AnyObject {

	func forwardTo(episode: Episode)

}

final class ShowDetailsCoordinator {

	let index: Show.Index
	let session: Session

	private weak var navigable: Navigable?
	private var episodeCoordinator: EpisodeCoordinator?

	init(show index: Show.Index, session: Session) {
		self.index = index
		self.session = session
	}

	func start(navigable: Navigable) {
		let downloader = ShowDetailsDownloader(network: session.network)

		let state = ShowDetailsState()
		let useCase = ShowDetailsInteractor(index: index, downloader: downloader, adapter: state)
		let viewModel = ShowDetailsViewModel(observing: state)
		
		let viewController = ShowDetailsViewController(useCase: useCase, viewModel: viewModel)
		viewController.title = index.name
		viewController.navigation = self

		navigable.navigateTo(view: viewController)

		self.navigable = navigable
	}

}

extension ShowDetailsCoordinator: ShowDetailsNavigating {

	func forwardTo(episode: Episode) {
		guard let navigable = navigable else { return }

		let episodeCoordinator = EpisodeCoordinator(episode: episode)
		episodeCoordinator.start(navigable: navigable)

		self.episodeCoordinator = episodeCoordinator
	}

}
