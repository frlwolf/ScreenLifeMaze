//  
//  ShowsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

final class ShowsCoordinator {

	let session: Session

	init(session: Session) {
		self.session = session
	}

	func start(embeddable: Embeddable) {
		let downloader = ShowsDownloader(network: session.network)
		let provider = ShowsProvider(downloader: downloader)

		let state = ShowsState()
		let interactor = ShowsInteractor(provider: provider, stateAdapter: state)
		let viewModel = ShowsViewModel(observing: state)

		let viewController = ShowsViewController(useCase: interactor, viewModel: viewModel)
		viewController.title = "Shows"

		embeddable.embed(view: viewController)
	}

}
