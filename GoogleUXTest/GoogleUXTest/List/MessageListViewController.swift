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
    
    // MARK: - Table view data source

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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtBottom {
            presenter.loadNextPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Remove") { (action, view, completionHandler) in
            completionHandler(true)
        }

        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration

    }
    
    /*override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
    }*/
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessageListViewController: MessageListPresentable {
    func updateList() {
        tableView.reloadData()
    }
}

extension UIScrollView {
    var distanceFromBottom: CGFloat {
        return contentSize.height - (contentOffset.y + frame.size.height)
    }

    var isAtBottom: Bool {
        let contentSizeHeight = contentSize.height
        let bottomInset = adjustedContentInset.bottom
        let contentOffsetBottom = contentOffset.y + frame.size.height - bottomInset
        return (contentSizeHeight >= contentOffsetBottom) && (distanceFromBottom <= 400)
    }
}
