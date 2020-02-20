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
    private lazy var loadingAndErrorRetryView: ErrorRetryView? = {
       let errorView = ErrorRetryView.loadFromNib()
        errorView?.retryHandler = { [weak self] in
            self?.presenter.loadMessages()
        }
        return errorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.loadMessages()
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
                if success { self?.tableView.deleteRows(at: [indexPath], with: .fade) }
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
        tableView.reloadData()
    }
    
    func showError() {
        loadingAndErrorRetryView?.showError()

        let isLoadingFirstPage = presenter.messages.isEmpty
        if isLoadingFirstPage {
            tableView.backgroundView = loadingAndErrorRetryView
        } else {
            // error occured while loading a subsequent page
            tableView.tableFooterView = loadingAndErrorRetryView
            tableView.tableFooterView?.layoutIfNeeded()
            //loadingAndErrorRetryView?.bounds = CGRect(x: .zero, y: .zero, width: tableView.bounds.width, height: 160.0)
            tableView.scrollRectToVisible(loadingAndErrorRetryView!.frame, animated: true)
        }
        tableView.reloadData()
    }
    
    func showLoading() {
        loadingAndErrorRetryView?.showLoading()
        
        let isLoadingFirstPage = presenter.messages.isEmpty
        if isLoadingFirstPage {
            // loading first page. Hence show a full screen loading
            tableView.backgroundView = loadingAndErrorRetryView
        } else {
            // loadind next page. Hence show loading indicator at the bottom of the list
            tableView.tableFooterView = loadingAndErrorRetryView
            tableView.tableFooterView?.layoutIfNeeded()
            //loadingAndErrorRetryView?.bounds = CGRect(x: .zero, y: .zero, width: tableView.bounds.width, height: 44.0)
        }
        
        tableView.reloadData()
    }
    
    func hideLoading() {
        tableView.backgroundView = nil
        tableView.tableFooterView = nil
    }

}
