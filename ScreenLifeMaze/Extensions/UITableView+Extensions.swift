//  
//  UITableView+Extensions.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import UIKit

extension UITableView {

	func register<T: UITableViewCell>(_: T.Type) {
		register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UITableViewCell>(row: Int) -> T {
		dequeueReusableCell(for: IndexPath(row: row, section: 0))
	}

	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
		}
		return cell
	}

}
