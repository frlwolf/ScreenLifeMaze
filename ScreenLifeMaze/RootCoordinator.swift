//  
//  RootCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

final class RootCoordinator {

	var showsCoordinator: ShowsCoordinator?

	func start(window: Window) {
		let view = RootViewController()
		view.setViewControllers(startTabs().viewControllers)

		window.rootView = view
		window.makeKeyAndVisible()
	}

	private func startTabs() -> UITabsEmbedder {
		let embedder = UITabsEmbedder()

		let showsCoordinator = ShowsCoordinator()
		showsCoordinator.start(embeddable: embedder)
		self.showsCoordinator = showsCoordinator

		return embedder
	}

}
