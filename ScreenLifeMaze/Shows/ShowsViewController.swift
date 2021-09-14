//  
//  ShowsViewController.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 13/09/21.
//

import UIKit
import Combine

final class ShowsViewController: UIViewController {

	let useCase: ShowsUseCase
	let viewModel: ShowsViewModel

	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

	private let dataSource: ShowsTableViewDataSource
	
	private var cancellables = [AnyCancellable]()

	init(useCase: ShowsUseCase, viewModel: ShowsViewModel) {
		self.useCase = useCase
		self.viewModel = viewModel

		dataSource = ShowsTableViewDataSource(viewModel: viewModel)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		preconditionFailure("Please do not instantiate this view controller with init?(coder:)")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black.withAlphaComponent(0.2)

		setupSubviews()
		setupLayout()
		
		viewModel.$shows
			.sink { [tableView] _ in tableView.reloadData() }
			.store(in: &cancellables)
		
		useCase.startLoadingContent()
	}

	private func setupSubviews() {
		tableView.register(UITableViewCell.self)
		tableView.dataSource = dataSource

		view.addSubview(tableView)
	}

	private func setupLayout() {
		view.addConstraints([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
			view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
		])
	}

}
