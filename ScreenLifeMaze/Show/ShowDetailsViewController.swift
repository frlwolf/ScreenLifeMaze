//  
//  ShowDetailsViewController.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import Foundation
import UIKit
import Combine

final class ShowDetailsViewController: UIViewController {

	let useCase: ShowDetailsUseCase
	let viewModel: ShowDetailsViewModel

	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

	private let coverView: ShowCoverView = {
		let coverView = ShowCoverView()
		coverView.translatesAutoresizingMaskIntoConstraints = false

		return coverView
	}()

	private var cancellables = [AnyCancellable]()

	init(useCase: ShowDetailsUseCase, viewModel: ShowDetailsViewModel) {
		self.useCase = useCase
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

		viewModel.$show
			.compactMap { $0 }
			.sink { [weak self] show in self?.updateHeader(show: show) }
			.store(in: &cancellables)

		viewModel.$episodes
			.sink { [tableView] _ in DispatchQueue.main.async(execute: tableView.reloadData) }
			.store(in: &cancellables)
		
		useCase.loadContent()
	}

	private func setupSubviews() {
		tableView.register(UITableViewCell.self)
		tableView.dataSource = self

		view.addSubview(tableView)
	}

	private func setupLayout() {
		view.addConstraints([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
			view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
		])
	}

	private func updateHeader(show: Show) {
		coverView.update(show: show)
		coverView.layoutIfNeeded()

		let height = coverView.systemLayoutSizeFitting(CGSize(width: tableView.frame.width, height: 0)).height
		let headerContainer = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: height)))

		headerContainer.addSubview(coverView)
		headerContainer.addConstraints([
			coverView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
			coverView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
			headerContainer.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
			headerContainer.bottomAnchor.constraint(equalTo: coverView.bottomAnchor)
		])
		headerContainer.preservesSuperviewLayoutMargins = true

		tableView.tableHeaderView = headerContainer
	}

}

extension ShowDetailsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.episodes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)

		let episode = viewModel.episodes[indexPath.row]
		cell.textLabel?.text = episode.name

		return cell
	}

}
