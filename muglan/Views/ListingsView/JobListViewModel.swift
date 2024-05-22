import FirebaseFirestore
import MessageUI
import FirebaseFirestoreSwift
import FirebaseAuth
import Foundation

// PostList for the list of items that are displayed
class JobListViewModel: ObservableObject {
    
    @Published var showingAddPostViewModel = false
    @Published var showErrorInSendMessage = false
    @Published var searchInput: String = ""
    @Published var showMailView = false
    @Published var allJobs: [Job] = [] {
        didSet {
            draftJobs = self.retrieveAllDraftJobs()
            publishedJobs = self.retreiveAllPublishedJobs()
        }
    }
    var draftJobs: [Job] = []
    var publishedJobs: [Job] = []
    
    private var db = Firestore.firestore()
    
    init() {
        retrieveAllPublishedJobs()
    }
    
    /**
     retrieve the list of job that are available from the database
     */
    func retrieveAllPublishedJobs() {
        db.collection("jobs").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching jobs: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No jobs found")
                return
            }
            
            self.allJobs = documents.compactMap { document in
                // Try to decode the document into a Job object
                guard let job = try? document.data(as: Job.self) else {
                    return nil
                }
                return job
            }
        }
    }
    
    /**
     method to retrieve all draft jobs
     */
    func retrieveAllDraftJobs()  -> [Job]{
        let creator = Auth.auth().currentUser?.uid;
        let filteredDraftJobs = allJobs.filter({
            $0.creator_id == creator && !$0.isPublished
        })
        return filteredDraftJobs;
    }
    
    /**
     method to retrieve all published jobs
     */
    func retreiveAllPublishedJobs() -> [Job] {
        let filteredPublishedJobs = allJobs.filter({
            $0.isPublished
        })
        return filteredPublishedJobs;
    }
    
    /**
     search for the selected item
     */
    func updateJobListingBasedOnSearchFilter(category: String) {
        if category == "job" {
            let filteredListings = allJobs.filter({
                $0.title.lowercased() == searchInput.lowercased()
            })
            
            self.allJobs = filteredListings.isEmpty ? allJobs : filteredListings
            return
        }
        else if category == "location" {
            let filteredListings = allJobs.filter({
                $0.city.lowercased() == searchInput.lowercased() ||
                $0.state.lowercased() == searchInput.lowercased()
            })
            
            self.allJobs = filteredListings.isEmpty ? allJobs : filteredListings
            return
        } else if category == "employment" {
            let filteredListings = allJobs.filter({
                $0.employment_type.lowercased() == searchInput.lowercased() ||
                $0.employment_type.lowercased() == searchInput.lowercased()
            })
            
            self.allJobs = filteredListings.isEmpty ? allJobs : filteredListings
            return
        } else {
            retrieveAllPublishedJobs()
        }
    }
    
    /**
     Add job lets the audience add a new job and update the ui accordingly. Once the user adds a job, it would be displayed in the list
     */
    func addJob(_ job: Job, completion: @escaping () -> Void) {
        db.collection("jobs").addDocument(data: job.asDictionary()) { error in
            if let error = error {
                print("error adding job: \(error.localizedDescription)")
                return
            }
            self.allJobs.append(job)
            completion()
        }
    }
    
    /**
     Delete a select job. Only creators can delete the job
     */
    func delete(id: String) {
        db.collection("jobs").document(id).delete { error in
            if let error = error {
                print("Error deleting job: \(error.localizedDescription)")
                return
            }
            self.allJobs.removeAll { $0.id == id }
        }
    }
    
    /**
     Returns true if the job is created by the current user.
     */
    func userCreatedJob(_ job: Job) -> Bool {
        return  job.creator_id == Auth.auth().currentUser?.uid
    }
    
    /**
     Check to ensure that the user can send mail
     */
    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    /**
     Only send email if the user has the ability to send email
     */
    func sendEmail(title: String, to recipient: String) {
        let subject = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = "I am interested in the job you posted.".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let email = "mailto:\(recipient)?subject=\(subject)&body=\(body)"
        
        print("Constructed Email URL: \(email)") // Debugging: Print the constructed email URL
        
        if let url = URL(string: email) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Can't open mail app")
                showErrorInSendMessage = true
            }
        } else {
            print("Invalid email URL")
            showErrorInSendMessage = true
        }
    }
}
