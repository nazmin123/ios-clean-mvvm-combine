//
//  PostViewModel.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//
import Combine
import Foundation

final class PostViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let fetchPostsUseCase: FetchPostsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchPostsUseCase: FetchPostsUseCaseProtocol) {
        self.fetchPostsUseCase = fetchPostsUseCase
    }
    
    func loadPosts() {
        isLoading = true
        errorMessage = nil
        
        fetchPostsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancellables)
    }
}


