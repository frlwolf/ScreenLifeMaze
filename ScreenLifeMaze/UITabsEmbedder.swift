//  
//  TabsEmbedder.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import UIKit

final class UITabsEmbedder: Embeddable {

	var viewControllers: [UIViewController] = []

	func embed(view: View) {
		guard let vc = view as? UIViewController else {
			fatalError("TabsEmbedder embedded views should be an instance of UIViewController")
		}
		viewControllers.append(vc)
	}

}
