//  
//  ShowsSearchCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit

final class ShowsSearchCoordinator {

	let session: Session

	init(session: Session) {
		self.session = session
	}

	func start(embeddingInside parentViewController: UIViewController) {
		let downloader = ShowsDownloader(network: session.network)

		let state = ShowsSearchState()
		let viewModel = ShowsSearchViewModel(observing: state)
		let interactor = ShowsSearchInteractor(adapter: state, downloader: downloader)

		let viewController = ShowsSearchViewController(useCase: interactor, viewModel: viewModel)

		let searchController = UISearchController(searchResultsController: viewController)
		searchController.searchResultsUpdater = viewController
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search TV Shows"

		parentViewController.definesPresentationContext = true
		parentViewController.navigationItem.searchController = searchController

		parentViewController.addChild(viewController)
	}

}
