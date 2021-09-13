//  
//  ShowsCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

final class ShowsCoordinator {

	func start(embeddable: Embeddable) {
		let viewController = ShowsViewController()
		viewController.title = "Shows"

		embeddable.embed(view: viewController)
	}

}
