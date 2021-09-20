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

	weak var navigation: ShowsNavigating?

	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false

		return tableView
	}()

	private let dataSource: ShowsTableViewDataSource
	private var cancellables = [AnyCancellable]()

	init(useCase: ShowsUseCase, viewModel: ShowsViewModel) {
		self.useCase = useCase
		self.viewModel = viewModel

		dataSource = ShowsTableViewDataSource(showsContainer: viewModel)

		super.init(nibName: nil, bundle: nil)
		
		tabBarItem.image = UIImage(named: "TVIcon")
	}

	required init?(coder: NSCoder) {
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
		
		useCase.startLoadingContent()
	}
	
	private func setupSubviews() {
		tableView.register(ShowsListCell.self)
		tableView.dataSource = dataSource
		tableView.prefetchDataSource = self
		tableView.delegate = self

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

extension ShowsViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)

		let show = viewModel.shows[indexPath.row]
		navigation?.forwardTo(show: show)
	}

}

extension ShowsViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		if let max = indexPaths.map(\.row).max(), max >= viewModel.shows.count - 10 {
			useCase.loadNext()
		}
	}

}
