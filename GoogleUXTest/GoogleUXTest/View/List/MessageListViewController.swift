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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        presenter.loadNextPage()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        return presenter.messages.count
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
        if scrollView.isAtBottom {
            presenter.loadNextPage()
        }
    }
}

extension MessageListViewController: MessageListPresentable {
    func updateList() {
        tableView.reloadData()
    }
}
