//  
//  Episode.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation

struct Episode: Decodable {

	let id: Int
	let name: String
	let season: Int

	let image: ImageSource?

}
