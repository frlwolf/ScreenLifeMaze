//  
//  ShowsSearchViewController.swift
//  ScreenLifeMaze
//
//  Created by Felipe Lobo on 15/09/21.
//

import UIKit
import Combine

final class ShowsSearchViewController: UIViewController {

	let useCase: ShowsSearchUseCase
	let viewModel: ShowsSearchViewModel

	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

	private let dataSource: ShowsTableViewDataSource
	private var cancellables = [AnyCancellable]()
	
	init(useCase: ShowsSearchUseCase, viewModel: ShowsSearchViewModel) {
		self.useCase = useCase
		self.viewModel = viewModel

		dataSource = ShowsTableViewDataSource(showsContainer: viewModel)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("Please do not instantiate this view controller with init?(coder:)")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSubviews()
		setupLayout()
		
		viewModel.$shows
			.sink { [tableView] _ in
				DispatchQueue.main.async {
					tableView.reloadData()
				}
			}
			.store(in: &cancellables)
	}

	private func setupSubviews() {
		tableView.register(ShowsListCell.self)
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

extension ShowsSearchViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		DispatchQueue.main.async { [useCase] in
			useCase.search(term: searchController.searchBar.text ?? "")
		}
	}

}
