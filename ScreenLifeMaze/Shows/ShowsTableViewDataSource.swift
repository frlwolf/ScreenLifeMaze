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

	weak var viewModel: ShowsViewModel!

	init(viewModel: ShowsViewModel) {
		self.viewModel = viewModel
	}

}

extension ShowsTableViewDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.shows.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ShowsListCell = tableView.dequeueReusableCell(for: indexPath)

		if let show = viewModel?.shows[indexPath.row] {
			cell.titleLabel.text = show.name
			cell.coverImageView.kf.setImage(with: show.image.medium)
		}

		return cell
	}

}
