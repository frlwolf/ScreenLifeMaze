//  
//  EpisodeViewController.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 19/09/21.
//

import UIKit
import Combine

final class EpisodeViewController: UIViewController {

	let viewModel: EpisodeViewModel

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false

		return scrollView
	}()

	private let backgroundView: UIView = {
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false

		return backgroundView
	}()

	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = .secondarySystemBackground
		imageView.clipsToBounds = true

		return imageView
	}()

	private let verticalStackView: UIStackView = {
		let verticalStackView = UIStackView()
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false
		verticalStackView.distribution = .fill
		verticalStackView.alignment = .fill
		verticalStackView.axis = .vertical
		verticalStackView.spacing = 8

		return verticalStackView
	}()

	private let titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .title1)
		titleLabel.numberOfLines = 2

		return titleLabel
	}()

	private let superTitleLabel: UILabel = {
		let superTitleLabel = UILabel()
		superTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		superTitleLabel.font = .preferredFont(forTextStyle: .headline)

		return superTitleLabel
	}()

	private let summaryLabel: UILabel = {
		let summaryLabel = UILabel()
		summaryLabel.translatesAutoresizingMaskIntoConstraints = false
		summaryLabel.font = .preferredFont(forTextStyle: .body)
		summaryLabel.numberOfLines = 0

		return summaryLabel
	}()

	private var cancellables = [AnyCancellable]()

	init(viewModel: EpisodeViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this view controller with init?(coder:)")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground

		setupSubviews()
		setupLayout()

		viewModel.$episode
			.sink { [weak self] episode in
				self?.updateChanged(episode: episode)
			}
			.store(in: &cancellables)
	}

	private func updateChanged(episode: Episode) {
		if let imageURL = episode.image?.original {
			imageView.kf.setImage(with: imageURL) { [unowned self] result in
				guard case .success(let imageResult) = result else { return }
				updateColors(derivingFrom: imageResult.image)
			}
		}

		let superTitle = String(format: "S%02dE%02d", episode.season, episode.number)
		superTitleLabel.text = superTitle

		titleLabel.text = episode.name

		if let attributedString = try? NSMutableAttributedString(
			data: Data(episode.summary.utf8),
			options: [.documentType: NSAttributedString.DocumentType.html],
			documentAttributes: nil
		) {
			let length = attributedString.length

			attributedString.setAttributes(
				[.font: UIFont.preferredFont(forTextStyle: .body)],
				range: NSRange(location: 0, length: length)
			)

			summaryLabel.attributedText = attributedString
		}
	}

	private func setupSubviews() {
		view.addSubview(scrollView)

		scrollView.addSubview(backgroundView)
		scrollView.addSubview(imageView)

		verticalStackView.addArrangedSubview(superTitleLabel)
		verticalStackView.addArrangedSubview(titleLabel)
		verticalStackView.addArrangedSubview(summaryLabel)

		scrollView.addSubview(verticalStackView)
	}

	private func setupLayout() {
		view.addConstraints([
			backgroundView.topAnchor.constraint(equalTo: imageView.topAnchor),
			backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 8),
			view.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),

			imageView.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
			imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9 / 16),

			verticalStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
			verticalStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: scrollView.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
			scrollView.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: verticalStackView.trailingAnchor, multiplier: 2),
			scrollView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor)
		])

		let stackViewWidthConstraint = verticalStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
		stackViewWidthConstraint.priority = .defaultHigh
		stackViewWidthConstraint.isActive = true
	}

	private func updateColors(derivingFrom image: UIImage) {
		guard let colors = image.getColors() else {
			debugPrint("Couldn't get colors from the specified image")
			return
		}

		imageView.backgroundColor = .black
		backgroundView.backgroundColor = colors.background
		titleLabel.textColor = colors.primary
		superTitleLabel.textColor = colors.detail
		summaryLabel.textColor = colors.secondary
	}

}
