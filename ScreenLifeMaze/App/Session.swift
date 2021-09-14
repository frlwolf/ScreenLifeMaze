//  
//  AppState.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import Foundation

final class Session {

	let network = Network()

}

extension Session {

	struct Network: NetworkSession {
		let session: URLSession
		init() {
			session = URLSession(configuration: .default)
		}
	}

}
