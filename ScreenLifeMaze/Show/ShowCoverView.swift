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
		verticalStackView.spacing = 8

		return verticalStackView
	}()

	private let coverBackgroundView: UIView = {
		let coverBackgroundView = UIView()
		coverBackgroundView.translatesAutoresizingMaskIntoConstraints = false
		coverBackgroundView.backgroundColor = .secondarySystemBackground

		return coverBackgroundView
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
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
		titleLabel.textColor = .label
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
		tagsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
		tagsLabel.textColor = .secondaryLabel

		return tagsLabel
	}()

	private var summaryHeightConstraint: NSLayoutConstraint?
	
	init() {
		super.init(frame: .zero)

		preservesSuperviewLayoutMargins = true

		setupSubviews()
		setupLayout()
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this view with init?(coder:)")
	}

	func update(show: Show, containerViewSize: CGSize) {
		coverImageView.kf.setImage(with: show.image.original) { [unowned self, coverBackgroundView] result in
			if case .success(let imageResult) = result {
				let mainColors = imageResult.image.mainColors()

				if let topColor = mainColors.last {
					let oneBeforeLast = max(0, mainColors.count - 2)
					backgroundColor	= mainColors[oneBeforeLast].withAlphaComponent(0.2)
					coverBackgroundView.backgroundColor = topColor
				}
			}
		}

		titleLabel.text = show.name

		if let attributedString = try? NSMutableAttributedString(
			data: Data(show.summary.utf8),
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil
		) {
			let length = attributedString.length
			attributedString.setAttributes(
				[.font: UIFont.preferredFont(forTextStyle: .body),
				 .foregroundColor: UIColor.label],
				range: NSRange(location: 0, length: length)
			)

			let height = height(forAttributedText: attributedString, containedIn: containerViewSize)
			
			summaryHeightConstraint?.constant = height
			summaryHeightConstraint?.isActive = true

			summaryLabel.attributedText = attributedString
		}

		tagsLabel.text = show.genres.joined(separator: ", ")
		tagsLabel.isHidden = show.genres.count == 0
	}

	private func setupSubviews() {
		addSubview(coverBackgroundView)
		addSubview(coverImageView)

		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(tagsLabel)
		verticalStackView.addArrangedSubview(summaryLabel)

		addSubview(verticalStackView)
	}

	private func setupLayout() {
		coverBackgroundView.heightAnchor.constraint(equalToConstant: 320).isActive = true
		
		let summaryHeightConstraint = summaryLabel.heightAnchor.constraint(equalToConstant: 0)
		summaryHeightConstraint.isActive = false
		
		self.summaryHeightConstraint = summaryHeightConstraint

		addConstraints([
			coverImageView.topAnchor.constraint(equalTo: topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			coverImageView.bottomAnchor.constraint(equalTo: coverBackgroundView.bottomAnchor),
			layoutMarginsGuide.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),

			coverBackgroundView.topAnchor.constraint(equalTo: topAnchor),
			coverBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: coverBackgroundView.trailingAnchor),

			verticalStackView.topAnchor.constraint(equalTo: coverBackgroundView.bottomAnchor, constant: 16),
			verticalStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			layoutMarginsGuide.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
			bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 8)
		])
	}

	private func height(forAttributedText attrString: NSAttributedString, containedIn size: CGSize) -> CGFloat {
		let textContainer = NSTextContainer()
		textContainer.lineBreakMode = .byWordWrapping
		textContainer.lineFragmentPadding = 0
		textContainer.size = CGSize(width: size.width, height: .greatestFiniteMagnitude)

		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)

		let textStorage = NSTextStorage()
		textStorage.addLayoutManager(layoutManager)
		textStorage.setAttributedString(attrString)

		layoutManager.ensureLayout(for: textContainer)

		let rect = layoutManager.usedRect(for: textContainer)

		return rect.height
	}

}
