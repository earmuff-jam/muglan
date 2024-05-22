//
//  AddPostView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/17/24.
//

import SwiftUI

struct AddPostView: View {
    
    @StateObject var viewModel = AddPostViewViewModel()
    @Binding var newPostPresented: Bool
    var jobListViewModel: JobListViewModel
    
    var body: some View {
        VStack{
            Text("Add New Job")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Form {
                Section(header: Text("Job Details")) {
                    TextField("Title", text: $viewModel.title)
                    TextField("Description", text: $viewModel.description)
                    DatePicker ("Due date", selection: $viewModel.dueDate, in: Date()...)
                }
                
                Section(header: Text("Location")) {
                    TextField("Street Address", text: $viewModel.street_address)
                    TextField("City", text: $viewModel.city)
                    TextField("Zipcode", text: $viewModel.zipcode)
                }
                
                Section(header: Text("Contact Information")) {
                    TextField("Email address", text: $viewModel.contact_email_address)
                        .keyboardType(.emailAddress)
                    TextField("Phone number", text: $viewModel.contact_phone_number)
                        .keyboardType(.phonePad)
                }
                
                MgButton(title: "Save", backgroundColor: (viewModel.canSave ? Color.blue : Color.gray)){
                    if viewModel.canSave {
                        viewModel.save()
                        newPostPresented = false
                        jobListViewModel.retrieveAllPublishedJobs()
                    } else {
                        viewModel.showAlert = true
                        viewModel.errorMessage = "All fields are required or did you select an earlier date? "
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 36) // Ensure the button expands to full width
                .padding(.horizontal)
                .disabled(!viewModel.canSave)
            }
            
            
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        }
        .padding()
    }
}

#Preview {
    AddPostView(newPostPresented: Binding(get: {return true}, set: { _ in} ), jobListViewModel: JobListViewModel())
}
