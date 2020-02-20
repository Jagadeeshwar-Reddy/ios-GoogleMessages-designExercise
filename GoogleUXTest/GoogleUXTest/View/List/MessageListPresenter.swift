//
//  MessageListPresenter.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

protocol MessageListPresentable: class {
    func showLoading()
    func hideLoading()
    
    func reloadMessages()
    func showError()
}

protocol MessageListPresenterType {
    var view: MessageListPresentable? { get set }
    var messages: Messages { get }
    
    func loadMessages()
    func loadNextPage()
    func removeMessage(at index: Int, completion: (Bool) -> Void)
}

final class MessageListPresenter: MessageListPresenterType {
    weak var view: MessageListPresentable?
    var messages: Messages = []
    
    private var currentPageInformation = PageInformation.firstPage
    private var isLoadingNextPage: Bool = false
    
    // to load first or current page
    func loadMessages() {
        loadNextPage()
    }
    
    func loadNextPage() {
        guard isLoadingNextPage == false else { return }
        
        isLoadingNextPage = true
        loadDataFor(page: currentPageInformation)
    }
    
    func removeMessage(at index: Int, completion: (Bool) -> Void) {
        guard index < messages.count else {
            completion(false)
            return
        }
        
        messages.remove(at: index)
        completion(true)
    }
}

// Private methods
extension MessageListPresenter {
    private func loadDataFor(page: PageInformation) {
        view?.showLoading()
        AppspotService.getMessages(forPage: page) { [weak self] (response, error) in
            self?.isLoadingNextPage = false
            
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                if let messagesResponse = response {
                    self?.handleSuccess(msgsResponse: messagesResponse)
                } else {
                    self?.handleFailure(error: error)
                }
            }
        }
    }
    
    private func handleSuccess(msgsResponse: MessagesResponse) {
        messages.append(contentsOf: msgsResponse.messages)
        let pageInfo = PageInformation(pageToken: msgsResponse.pageToken, count: msgsResponse.count)
        currentPageInformation = pageInfo
        view?.reloadMessages()
    }
    
    private func handleFailure(error: APIDataTaskError?) {
        view?.showError()
    }
}
