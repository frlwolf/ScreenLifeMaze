//  
//  RootCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

final class RootCoordinator {

	let session: Session

	var showsCoordinator: ShowsCoordinator?

	init() {
		session = Session()
	}

	func start(window: Window) {
		let view = RootViewController()
		view.setViewControllers(startTabs().viewControllers)

		window.rootView = view
		window.makeKeyAndVisible()
	}

	private func startTabs() -> UITabsEmbedder {
		let embedder = UITabsEmbedder()

		let showsCoordinator = ShowsCoordinator(session: session)
		showsCoordinator.start(embeddable: embedder)
		self.showsCoordinator = showsCoordinator

		return embedder
	}

}
