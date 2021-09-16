//  
//  ShowEpisodesDataSource.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit
import Kingfisher

protocol EpisodesContaining {

	var episodes: [Episode] { get }

}

final class ShowEpisodesDataSource: NSObject {

	let episodesContainer: EpisodesContaining

	private var sections: [[Episode]] = []

	init(episodesContainer: EpisodesContaining) {
		self.episodesContainer = episodesContainer
	}

	func rebuildSections() {
		sections = episodesContainer.episodes
			.reduce(into: [Array<Episode>]()) { seed, episode in
				guard var previousArray = seed.popLast() else {
					seed = [[episode]]
					return
				}
				guard let previousEpisode = previousArray.last else {
					return
				}
				if previousEpisode.season == episode.season {
					previousArray.append(episode)
					seed.append(previousArray)
				} else {
					seed.append(previousArray)
					seed.append([episode])
				}
			}
	}

}

extension ShowEpisodesDataSource: UITableViewDataSource {

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		"Season \(section + 1)"
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sections[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)

		cell.selectionStyle = .none

		let section = sections[indexPath.section]
		let episode = section[indexPath.row]
		cell.textLabel?.text = episode.name
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.textLabel?.minimumScaleFactor = 0.7

		if let imageURL = episode.image?.medium {
			cell.imageView?.kf.setImage(with: imageURL) { [weak cell] _ in
				cell?.setNeedsLayout()
				cell?.layoutIfNeeded()
			}
		} else {
			cell.imageView?.image = nil
		}

		return cell
	}

}
