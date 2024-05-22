//
//  PostView.swift
//  muglan
//
//  View used for a single post.
//  Created by Mohit Paudyal on 5/17/24.
//

import SwiftUI

struct ItemView: View {
    
    @StateObject var viewModel = ItemViewViewModel()
    let job: Job
    var jobListViewModel: JobListViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(job.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("\(Date(timeIntervalSince1970: job.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button{
                viewModel.showingSelectedJobViewModel = true
            }label: {
                Group {
                    if !job.isPublished && jobListViewModel.userCreatedJob(job) {
                        Image(systemName: "pencil.and.list.clipboard")
                            .foregroundColor(.blue)
                    } else if jobListViewModel.userCreatedJob(job) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    } else if job.isPublished {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "pencil.and.list.clipboard")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingSelectedJobViewModel) {
                JobDetailsView(newPostPresented: $viewModel.showingSelectedJobViewModel, job: job, jobListViewModel: jobListViewModel)
            }
        }
    }
}

#Preview {
    ItemView(job: Job( id: "ID",
                       title: "Preview Title",
                       description: "Preview Description",
                       street_address: "Preview Street Address",
                       city: "Preview City",
                       state: "Preview State",
                       employment_type: "Preview Employment Type",
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
                       isPublished: false), jobListViewModel: JobListViewModel()
    )
}
