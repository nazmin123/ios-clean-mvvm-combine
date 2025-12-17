//
//  PostListView.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//

import SwiftUI

struct PostListView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title).font(.headline)
                    Text(post.body).font(.subheadline)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Posts")
            .onAppear { viewModel.loadPosts() }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }
    }
}
