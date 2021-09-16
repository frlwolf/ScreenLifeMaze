//  
//  ShowDetailsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

final class ShowDetailsCoordinator {

	let index: Show.Index
	let session: Session

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

		navigable.navigateTo(view: viewController)
	}

}
