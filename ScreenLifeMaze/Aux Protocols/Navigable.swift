//  
//  Navigable.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit

protocol Navigable: AnyObject {

	func navigateTo(view: View)

}

extension UINavigationController: Navigable {

	func navigateTo(view: View) {
		guard let vc = view as? UIViewController else {
			fatalError("UINavigationController's 'to navigate view' should be an instance of UIViewController")
		}

		pushViewController(vc, animated: true)
	}

}
