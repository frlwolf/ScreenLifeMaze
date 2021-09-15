//  
//  ShowsListCell.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import UIKit

final class ShowsListCell: UITableViewCell {

	let coverImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = .gray

		return imageView
	}()

	let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		return titleLabel
	}()

	override init(style: CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupSubviews()
		setupLayout()
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this view controller with init?(coder:)")
	}

	private func setupSubviews() {
		contentView.addSubview(coverImageView)
		contentView.addSubview(titleLabel)
	}

	private func setupLayout() {
		contentView.addConstraints([
			coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor, multiplier: 3 / 4),
			contentView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),

			titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 16),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
			contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
		])
		
		let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 80)
		heightConstraint.priority = UILayoutPriority(rawValue: 900)
		heightConstraint.isActive = true
	}

}
