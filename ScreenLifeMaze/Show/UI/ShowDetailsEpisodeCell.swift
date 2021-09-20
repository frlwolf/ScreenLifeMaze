//  
//  ShowDetailsEpisodeCell.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 19/09/21.
//

import UIKit

final class ShowDetailsEpisodeCell: UITableViewCell {

	let coverImageView: UIImageView = {
		let coverImageView = UIImageView()
		coverImageView.translatesAutoresizingMaskIntoConstraints = false
		coverImageView.backgroundColor = .secondarySystemBackground

		return coverImageView
	}()

	let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.minimumScaleFactor = 0.7

		return titleLabel
	}()

	override init(style: CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupSubviews()
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this cell with init?(coder:)")
	}

	func setupSubviews() {
		contentView.addSubview(coverImageView)
		contentView.addSubview(titleLabel)
	}

	func setupLayout() {
		addConstraints([
			coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor, multiplier: 16 / 9),

			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: coverImageView.trailingAnchor, multiplier: 1),
			titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		])
	}

}
