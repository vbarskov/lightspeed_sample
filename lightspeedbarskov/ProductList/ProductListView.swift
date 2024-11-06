//
//  ProductListView.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit


protocol ProductListViewOutput: AnyObject {
    func loadData()
    func loadMoreData()
}

protocol ProductListViewLogic: UIView {
    var output: ProductListViewOutput? { get set }
    
    func update(viewModel: ProductListFlow.InputData.ViewModel)
    
}

final class ProductListView: UIView {
    
    
    enum Constants {
        static var cornerRadius: CGFloat = 8
        static var padding: CGFloat = 16
        static var loadMoreOffset: CGFloat = 50
    }
    
    private var viewModel: ProductListModels.ViewModel?
    weak var output: ProductListViewOutput?
    private var isLoadingMoreData = false
    
    // MARK: - Views
    private let tableView: UITableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
        return view
    }()
    // MARK: - Init
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    //
    
    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        addConstraints()
        configureTableView()
    }
    
    private func addSubviews() {
        addSubview(safeAreaBackgroundView)
        addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    @objc private func refreshData() {
        output?.loadData()
    }
    
}

// MARK: - Table View Source

extension ProductListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.row]
        if let vm = item as? ProductCellVM {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
            cell.viewModel = vm
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - Table View Delegate

extension ProductListView: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height - Constants.loadMoreOffset {
            guard let viewModel = self.viewModel else { return }
            if viewModel.state == .dataLoaded && !isLoadingMoreData {
                isLoadingMoreData = true
                output?.loadMoreData()
            }
        }
    }
    
}

// MARK: - ProductListViewLogic

extension ProductListView: ProductListViewLogic {
        
    func update(viewModel: ProductListFlow.InputData.ViewModel) {
        
        switch viewModel.state {
        case .loading, .initial:
            refreshControl.beginRefreshing()
        case .dataLoaded:
            refreshControl.endRefreshing()
            tableView.contentInset.bottom = 0
            isLoadingMoreData = false
        default:
            break
        }
        
        isUserInteractionEnabled = viewModel.state != .loading
        
        self.viewModel = viewModel
        
        tableView.reloadData()
        
        layoutIfNeeded()
        
    }
    
    
}



