//
//  MessageListViewController.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 13/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

final class MessageListViewController: UITableViewController {
    
    private lazy var presenter: MessageListPresenterType = MessageListPresenter()
    private lazy var errorRetryView: ErrorRetryView? = {
       let errorView = ErrorRetryView.loadFromNib()
        errorView?.retryHandler = { [weak self] in
            self?.presenter.loadMessages()
        }
        return errorView
    }()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.tintColor = UIColor.systemGray
        return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.loadMessages()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            // do whatever you want when the app is brought back to the foreground
            if self?.presenter.messages.isEmpty ?? false {
                self?.presenter.loadMessages()
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messageDetailVC = segue.destination as? MessageDetailViewController,
            let selectedCell = sender as? MessageTableViewCell,
            let selectedRowIndex = tableView.indexPath(for: selectedCell)?.row {
            messageDetailVC.messageModel = presenter.messages[selectedRowIndex]
        }
    }
}

// MARK: - Table view data source
extension MessageListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.backgroundView == nil ? presenter.messages.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else {
            fatalError("Cell should be of MessageTableViewCell type")
        }

        // Configure the cell...
        cell.configure(with: presenter.messages[indexPath.row])
        return cell
    }
}

// MARK: - Table view delegate
extension MessageListViewController {
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { [weak self] () -> UIViewController? in
            let detailVC = self?.storyboard?.instantiateViewController(identifier: "MessageDetailView") as? MessageDetailViewController
            detailVC?.messageModel = self?.presenter.messages[indexPath.row]
            return detailVC
        })
        
        return configuration
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeMessage(at: indexPath.row, completion: { [weak self] success in
                if success {
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    if self?.presenter.messages.isEmpty ?? false {
                        self?.showEmptyState()
                    }
                }
            })
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtBottom, tableView.tableFooterView == nil {
            presenter.loadNextPage()
        }
    }
}

// MARK: - MessageListPresentable
extension MessageListViewController: MessageListPresentable {
    func reloadMessages() {
        if presenter.messages.isEmpty {
            showEmptyState()
        }
        tableView.reloadData()
    }
    
    func showError() {
        let isLoadingFirstPage = presenter.messages.isEmpty
        if isLoadingFirstPage {
            tableView.backgroundView = errorRetryView
        } else { // error occured while loading a subsequent page
            tableView.tableFooterView = errorRetryView
            errorRetryView?.bounds = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 140.0))
            tableView.scrollRectToVisible(errorRetryView!.frame, animated: true)
        }
        tableView.reloadData()
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        
        let isLoadingFirstPage = presenter.messages.isEmpty
        if isLoadingFirstPage { // loading first page. Hence show a full screen loading
            tableView.backgroundView = loadingIndicator
        } else { // loadind next page. Hence show loading indicator at the bottom of the list
            tableView.tableFooterView = loadingIndicator
            loadingIndicator.bounds = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 44.0))
        }
        
        tableView.reloadData()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
        tableView.backgroundView = nil
        tableView.tableFooterView = nil
    }

    private func showEmptyState() {
        let emptyStateLabel = UILabel()
        emptyStateLabel.numberOfLines = 2
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.text = "All caught up!\n No messages for now."
        tableView.tableFooterView = nil
        tableView.backgroundView = emptyStateLabel
    }
}
