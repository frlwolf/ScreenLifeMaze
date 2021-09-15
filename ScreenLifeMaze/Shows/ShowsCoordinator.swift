//  
//  ShowsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

protocol ShowsNavigation: AnyObject {

	func forwardTo(show: Show)

}

final class ShowsCoordinator {

	let session: Session

	private var showsSearchCoordinator: ShowsSearchCoordinator?
	private var showDetailsCoordinator: ShowDetailsCoordinator?

	private weak var navigationController: NavigationController?

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
		viewController.navigation = self

		let navigationController = NavigationController(rootViewController: viewController)

		let showsSearchCoordinator = ShowsSearchCoordinator(session: session)
		showsSearchCoordinator.navigationDelegate = self
		showsSearchCoordinator.start(embeddingInside: viewController)

		embeddable.embed(view: navigationController)

		self.navigationController = navigationController
		self.showsSearchCoordinator = showsSearchCoordinator
	}

}

extension ShowsCoordinator: ShowsNavigation {

	func forwardTo(show: Show) {
		guard let navigationController = navigationController else { return }
		
		let showDetailsCoordinator = ShowDetailsCoordinator(show: show, session: session)
		showDetailsCoordinator.start(navigable: navigationController)
		
		self.showDetailsCoordinator = showDetailsCoordinator
	}

}

extension ShowsCoordinator: ShowsSearchCoordinatorNavigationDelegate {

	func wantsToNavigate(to show: Show) {
		forwardTo(show: show)
	}

}
