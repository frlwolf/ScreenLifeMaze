//  
//  Show.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import Foundation

struct Show: Decodable {

	struct ImageSource: Decodable {
		let medium: URL
		let original: URL
	}

	let name: String
	let image: ImageSource

}
