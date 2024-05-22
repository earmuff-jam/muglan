//
//  DraftJobListView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/20/24.
//

import SwiftUI
import FirebaseAuth

struct DraftJobListView: View {
    
    @StateObject var viewModel = JobListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.draftJobs.isEmpty {
                    Text("No matching results found...")
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    List(viewModel.draftJobs) { job in
                        ItemView(job: job, jobListViewModel: viewModel)
                            .swipeActions {
                                if job.creator_id == Auth.auth().currentUser?.uid {
                                    Button("Delete") {
                                        viewModel.delete(id: job.id)
                                    }
                                    .tint(.red)
                                }
                            }
                    }
                    .listStyle(PlainListStyle())
                    
                }
            }
            .navigationTitle("Draft jobs")
            .toolbar {
                Button {
                    viewModel.showingAddPostViewModel = true
                } label : {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingAddPostViewModel) {
                AddPostView(newPostPresented: $viewModel.showingAddPostViewModel, jobListViewModel: viewModel)
            }
            .alert(isPresented: $viewModel.showErrorInSendMessage) {
                Alert(title: Text("Error"), message: Text("Device cannot send mail."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    DraftJobListView()
}
