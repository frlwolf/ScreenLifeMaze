//  
//  UIColor+Contrast.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 17/09/21.
//

import UIKit

extension UIColor {

	var contrast: CGFloat {
		var red = CGFloat.zero
		var green = CGFloat.zero
		var blue = CGFloat.zero

		getRed(&red, green: &green, blue: &blue, alpha: nil)

		// ((Red value * 299) + (Green value * 587) + (Blue value * 114)) / 1000.
		return ((red * 255) * 299 + (green * 255) * 587 + (blue * 255) * 114) / 1000
	}

}
