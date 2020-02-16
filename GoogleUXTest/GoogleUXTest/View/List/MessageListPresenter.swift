//
//  MessageListPresenter.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import Foundation

protocol MessageListPresentable: class {
    func updateList()
}

protocol MessageListPresenterType {
    var view: MessageListPresentable? { get set }
    var messages: Messages { get }
    
    func loadNextPage()
    func removeMessage(at index: Int, completion: (Bool) -> Void)
}

final class MessageListPresenter: MessageListPresenterType {
    weak var view: MessageListPresentable?
    var messages: Messages = []
    
    private var currentPageInformation = PageInformation.firstPage
    private var isLoadingNextPage: Bool = false
    
    func loadNextPage() {
        guard isLoadingNextPage == false else { return }
        
        isLoadingNextPage = true
        AppspotService.getMessages(forPage: currentPageInformation) { [weak self] (messagesResponse, error) in
            self?.isLoadingNextPage = false
            if let messagesResponse = messagesResponse {
                self?.messages.append(contentsOf: messagesResponse.messages)
                let pageInfo = PageInformation(pageToken: messagesResponse.pageToken, count: messagesResponse.count)
                self?.currentPageInformation = pageInfo
                self?.view?.updateList()
            }
        }
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
