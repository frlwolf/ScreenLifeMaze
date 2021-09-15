//  
//  ShowsTableViewDataSource.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import Foundation
import UIKit
import Kingfisher

final class ShowsTableViewDataSource: NSObject {

	let showsContainer: ShowsContaining

	init(showsContainer: ShowsContaining) {
		self.showsContainer = showsContainer
	}

}

extension ShowsTableViewDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		showsContainer.shows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let show = showsContainer.shows[indexPath.row]

		let cell: ShowsListCell = tableView.dequeueReusableCell(for: indexPath)
		cell.titleLabel.text = show.name
		cell.accessoryType = .disclosureIndicator

		if let imageUrl = show.image?.medium {
			cell.coverImageView.kf.setImage(with: imageUrl)
		} else {
			cell.coverImageView.image = nil
		}

		return cell
	}

}
