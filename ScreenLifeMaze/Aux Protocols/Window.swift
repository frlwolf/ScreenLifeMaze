//  
//  Window.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import UIKit

protocol Window: AnyObject {

	var rootView: View? { get set }

	func makeKeyAndVisible()

}

extension UIWindow: Window {

	var rootView: View? {
		get { rootViewController }
		set {
			guard let vc = newValue as? UIViewController else {
				fatalError("Window's embedded root view should be an instance of UIViewController")
			}
			rootViewController = vc
		}
	}

}
