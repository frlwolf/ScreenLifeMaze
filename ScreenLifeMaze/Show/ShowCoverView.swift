//  
//  ShowCoverView.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit
import Kingfisher

final class ShowCoverView: UIView {

	private let verticalStackView: UIStackView = {
		let verticalStackView = UIStackView()
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false
		verticalStackView.distribution = .fill
		verticalStackView.alignment = .fill
		verticalStackView.axis = .vertical
		verticalStackView.spacing = 12

		return verticalStackView
	}()

	private let coverImageView: UIImageView = {
		let coverImageView = UIImageView()
		coverImageView.translatesAutoresizingMaskIntoConstraints = false
		coverImageView.contentMode = .scaleAspectFit

		return coverImageView
	}()

	private let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
		titleLabel.numberOfLines = 0

		return titleLabel
	}()

	private let summaryLabel: UILabel = {
		let summaryLabel = UILabel()
		summaryLabel.translatesAutoresizingMaskIntoConstraints = false
		summaryLabel.numberOfLines = 0

		return summaryLabel
	}()

	private let tagsLabel: UILabel = {
		let tagsLabel = UILabel()
		tagsLabel.translatesAutoresizingMaskIntoConstraints = false
		tagsLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		tagsLabel.textColor = .secondaryLabel

		return tagsLabel
	}()

	init() {
		super.init(frame: .zero)

		preservesSuperviewLayoutMargins = true

		setupSubviews()
		setupLayout()
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this view with init?(coder:)")
	}

	func update(show: Show) {
		coverImageView.kf.setImage(with: show.image.original)

		titleLabel.text = show.name

		if let attributedString = try? NSMutableAttributedString(
			data: Data(show.summary.utf8),
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil
		) {
			let length = attributedString.length
			attributedString.setAttributes([.font: UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: length))
	
			summaryLabel.attributedText = attributedString
		}

		tagsLabel.text = show.genres.joined(separator: ", ")
	}

	private func setupSubviews() {
		verticalStackView.addArrangedSubview(coverImageView)
		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(summaryLabel)
		verticalStackView.addArrangedSubview(tagsLabel)

		addSubview(verticalStackView)
	}

	private func setupLayout() {
		coverImageView.heightAnchor.constraint(equalToConstant: 320).isActive = true

		addConstraints([
			verticalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			layoutMarginsGuide.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
			layoutMarginsGuide.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 8)
		])
	}

}
