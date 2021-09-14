//  
//  ReusableView.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import UIKit

protocol ReusableView: AnyObject {
	static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
	static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
