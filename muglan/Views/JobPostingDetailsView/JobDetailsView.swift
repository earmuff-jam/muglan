//
//  JobDetailsView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/17/24.
//

import SwiftUI

struct JobDetailsView: View {
    
    @StateObject var viewModel = AddPostViewViewModel()
    @Binding var newPostPresented: Bool
    let job: Job
    
    init(newPostPresented: Binding<Bool>, job: Job) {
        self._newPostPresented = newPostPresented
        self.job = job
        _viewModel = StateObject(wrappedValue: AddPostViewViewModel())
    }
    
    var body: some View {
        VStack{
            Text("View job details")
                .font(.system(size: 24))
                .bold()
                .padding(.top, 50)
            
            Form {
                
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Description", text: $viewModel.description)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Street Address", text: $viewModel.street_address)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("City", text: $viewModel.city)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Zipcode", text: $viewModel.zipcode)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Email address", text: $viewModel.contact_email_address)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Phone number", text: $viewModel.contact_phone_number)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("State", text: $viewModel.state)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Employment Type", text: $viewModel.employment_type)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                TextField("Working schedule", text: $viewModel.working_schedule)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Toggle("Is hourly salary?", isOn: $viewModel.salary_is_hourly)
                
                Toggle("Is negotiable?", isOn: $viewModel.salary_is_negotiable)
                
                TextField("Salary Rate", text: $viewModel.salary_rate)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                DatePicker ("Due date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Button(action: {
                    if !viewModel.canEdit(creatorID: viewModel.creatorID) {
                           viewModel.showAlert = true
                           viewModel.errorMessage = "Creator can only update job. Is this a mistake? "
                       } else if viewModel.canUpdate {
                           viewModel.update(id: job.id)
                           newPostPresented = false
                       } else {
                           viewModel.showAlert = true
                           viewModel.errorMessage = "All fields are required or did you select an earlier date ? "
                       }
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage) )
                }
            }
        }
        .onAppear {
            // Pre-fill the form with the job details
            viewModel.title = job.title
            viewModel.description = job.description
            viewModel.street_address = job.street_address
            viewModel.city = job.city
            viewModel.state = job.state
            viewModel.employment_type = job.employment_type
            viewModel.working_schedule = job.working_schedule
            viewModel.salary_rate = job.salary_rate
            viewModel.salary_is_negotiable = job.salary_is_negotiable
            viewModel.salary_is_hourly = job.salary_is_hourly
            viewModel.zipcode = job.zipCode
            viewModel.creatorID = job.creator_id ?? ""
            viewModel.contact_email_address = job.creator_email_address
            viewModel.contact_phone_number = job.creator_phone_number
            viewModel.dueDate = Date(timeIntervalSince1970: job.dueDate)
        }
    }
}

#Preview {
    JobDetailsView(newPostPresented: .constant(true), job: Job(
        id: "ID",
        title: "title",
        description: "description",
        street_address: "street address",
        city: "city",
        state: "state",
        employment_type: "full time",
        working_schedule: "9-5",
        salary_rate: "10$/hr",
        salary_is_negotiable: false,
        salary_is_hourly: true,
        zipCode: "zipCode",
        creator_id: "creatorID",
        creator_email_address: "creator email address",
        creator_phone_number: "creator phone number",
        dueDate: Date().timeIntervalSince1970,
        createdDate: Date().timeIntervalSince1970,
        isPublished: false
    ))
}
