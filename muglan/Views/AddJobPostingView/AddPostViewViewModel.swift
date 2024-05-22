//
//  AddPostViewViewModel.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AddPostViewViewModel: ObservableObject {

    @Published var title = ""
    @Published var description = ""
    
    @Published var street_address = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipcode = ""
    
    @Published var employment_type = ""
    @Published var working_schedule = ""
    
    @Published var salary_rate = ""
    @Published var salary_is_negotiable = false
    @Published var salary_is_hourly = false
    
    @Published var creatorID = ""
    @Published var contact_email_address = ""
    @Published var contact_phone_number = ""
    
    @Published var dueDate = Date()
    @Published var errorMessage = ""
    @Published var showAlert = false

    init () {}
    
    func update(id: String) {
        guard canUpdate() else {
            return;
        }
        
        // get current user id
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // create a model
        let existingJobPosting = Job(
            id: id,
            title: title,
            description: description,
            street_address: street_address,
            city: city,
            state: state,
            employment_type: employment_type,
            working_schedule: working_schedule,
            salary_rate: salary_rate,
            salary_is_negotiable: salary_is_negotiable,
            salary_is_hourly: salary_is_hourly,
            zipCode: zipcode,
            creator_id: nil,
            creator_email_address: contact_email_address,
            creator_phone_number: contact_phone_number,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isPublished: true
        )
        
        let db = Firestore.firestore()
          
        db.collection("jobs")
               .document(id)
               .setData(existingJobPosting.asDictionary(), merge: true) { error in
                   if let error = error {
                       print("Error updating document: \(error.localizedDescription)")
                   } else {
                       print("Document successfully updated")
                   }
               }
    }
    
    func save() {
        guard canSave else {
            return;
        }
        
        // get current user id
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // create a model
        let newID = UUID().uuidString
        let newJobPosting = Job(
            id: newID,
            title: title,
            description: description,
            street_address: street_address,
            city: city,
            state: state,
            employment_type: employment_type,
            working_schedule: working_schedule,
            salary_rate: salary_rate,
            salary_is_negotiable: salary_is_negotiable,
            salary_is_hourly: salary_is_hourly,
            zipCode: zipcode,
            creator_id: userID,
            creator_email_address: contact_email_address,
            creator_phone_number: contact_phone_number,
            dueDate: dueDate.timeIntervalSince1970,
            createdDate: Date().timeIntervalSince1970,
            isPublished: false
        )
        
        // save the model to the db
        let db = Firestore.firestore()
        
        db.collection("jobs")
            .document(newID)
            .setData(newJobPosting.asDictionary())
    }
    
    var canSave: Bool {
        
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !street_address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !contact_email_address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !contact_phone_number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    return false
                }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
    
    
    // only creators can edit
    func canEdit(creatorID: String?) -> Bool {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        guard let creatorID = creatorID, creatorID == userID else {
               return false
           }
        return true
        
    }
    
    
    func canUpdate() -> Bool {
        
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !street_address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !zipcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !employment_type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !working_schedule.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !salary_rate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !contact_email_address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !contact_phone_number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    return false
                }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
}
