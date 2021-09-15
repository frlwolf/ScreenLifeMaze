//  
//  ShowDetailsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

final class ShowDetailsCoordinator {

	let show: Show
	let session: Session

	init(show: Show, session: Session) {
		self.show = show
		self.session = session
	}

	func start(navigable: Navigable) {
		let viewController = ShowDetailsViewController()
		viewController.title = show.name

		navigable.navigateTo(view: viewController)
	}

}
