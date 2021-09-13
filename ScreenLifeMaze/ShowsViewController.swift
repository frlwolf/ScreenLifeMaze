//  
//  ShowsViewController.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import UIKit

final class ShowsViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("Please do not instantiate this view controller with init?(coder:)")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black.withAlphaComponent(0.2)
	}

}
