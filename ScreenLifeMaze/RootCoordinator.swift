//  
//  RootCoordinator.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

final class RootCoordinator {

	func start(window: Window) {
		let view = RootViewController()

		window.rootView = view
		window.makeKeyAndVisible()
	}

}
