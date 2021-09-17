//  
//  ShowCoverView.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit
import Kingfisher
import UIImageColors

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

	private let backgroundImageView: UIImageView = {
		let backgroundImageView = UIImageView()
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.clipsToBounds = true

		return backgroundImageView
	}()

	private let backgroundVisualEffectView: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .systemMaterial)
		let backgroundVisualEffectView = UIVisualEffectView(effect: blurEffect)
		backgroundVisualEffectView.translatesAutoresizingMaskIntoConstraints = false
		backgroundVisualEffectView.contentMode = .scaleAspectFill

		return backgroundVisualEffectView
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
		coverImageView.kf.setImage(with: show.image.original) { [unowned self] result in
			if case .success(let imageResult) = result, let colors = imageResult.image.getColors() {
				backgroundImageView.image = imageResult.image
				
				if colors.secondary.contrast > 125 {
					backgroundVisualEffectView.effect = UIBlurEffect(style: .systemThickMaterialDark)
				} else {
					backgroundVisualEffectView.effect = UIBlurEffect(style: .systemThickMaterialLight)
				}
				
				backgroundColor	= colors.background
				coverBackgroundView.backgroundColor = colors.background
				titleLabel.textColor = colors.primary
				tagsLabel.textColor = colors.detail
				summaryLabel.textColor = colors.secondary
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
				[.font: UIFont.preferredFont(forTextStyle: .body)],
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
		addSubview(backgroundImageView)
		addSubview(backgroundVisualEffectView)

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

		titleLabel.setContentHuggingPriority(.required, for: .vertical)
		tagsLabel.setContentHuggingPriority(.required, for: .vertical)

		addConstraints([
			backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

			backgroundVisualEffectView.topAnchor.constraint(equalTo: topAnchor),
			backgroundVisualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
			backgroundVisualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
			backgroundVisualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),

			coverImageView.topAnchor.constraint(equalTo: topAnchor),
			coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			coverImageView.bottomAnchor.constraint(equalTo: coverBackgroundView.bottomAnchor),
			trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),

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
