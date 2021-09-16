//  
//  Show.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

struct Show: Decodable {

	struct Schedule: Decodable {
		let time: String
		let days: [String]
	}

	let id: Int
	let name: String
	let summary: String
	let genres: [String]
	let image: ImageSource

}
