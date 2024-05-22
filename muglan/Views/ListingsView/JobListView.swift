import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct JobListView: View {
    
    @State private var showSearchView = false
    @State private var showMailView = false
    @State private var title = ""
    @State private var emailRecipient = ""
    @StateObject var viewModel = JobListViewModel()
    
    var body: some View {
        NavigationView {
            if showSearchView {
                SearchView(show: $showSearchView, searchInput: $viewModel.searchInput, searchJob: viewModel.updateJobListingBasedOnSearchFilter)
            } else {
                VStack {
                    SearchAndFilter(searchInput: $viewModel.searchInput)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                showSearchView.toggle()
                            }
                        }
                    if viewModel.publishedJobs.isEmpty {
                        Text("No matching results found...")
                            .foregroundColor(.gray)
                            .font(.headline)
                    } else {
                        List(viewModel.publishedJobs) { job in
                            ItemView(job: job, jobListViewModel: viewModel)
                                .swipeActions {
                                    if job.creator_id == Auth.auth().currentUser?.uid {
                                        Button("Delete") {
                                            viewModel.delete(id: job.id)
                                        }
                                        .tint(.red)
                                    } else {
                                        Button("Apply") {
                                            if viewModel.canSendMail() {
                                                viewModel.sendEmail(title: job.title, to: job.creator_email_address)
                                            } else {
                                                viewModel.showErrorInSendMessage = true
                                            }
                                        }
                                        .tint(.green)
                                    }
                                }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle("View jobs")
                .toolbar {
                    Button {
                        viewModel.showingAddPostViewModel = true
                    } label: {
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
}

#Preview {
    JobListView()
}
