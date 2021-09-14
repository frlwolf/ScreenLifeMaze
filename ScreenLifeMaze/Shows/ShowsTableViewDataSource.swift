//  
//  ShowsTableViewDataSource.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 14/09/21.
//

import Foundation
import UIKit

final class ShowsTableViewDataSource: NSObject {

	weak var viewModel: ShowsViewModel?

	init(viewModel: ShowsViewModel) {
		self.viewModel = viewModel
	}

}

extension ShowsTableViewDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.shows.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)

		if let shows = viewModel?.shows {
			cell.textLabel?.text = shows[indexPath.row].name
		}

		return cell
	}

}
