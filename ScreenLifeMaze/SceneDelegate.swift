//
//  SceneDelegate.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	var coordinator: RootCoordinator?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let window = UIWindow(windowScene: windowScene)

		self.window = window
		
		let coordinator = RootCoordinator()
		coordinator.start(window: window)
		
		self.coordinator = coordinator
	}

}
