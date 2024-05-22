//
//  SearchView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/18/24.
//

import SwiftUI


// Selected view in the search option
enum SearchViewOptions {
    case location
    case jobTitle
    case employmentType
}

struct SearchView: View {
    
    @Binding var show: Bool
    @Binding var searchInput: String
    var searchJob: (String) -> Void
    @State private var selectedOption: SearchViewOptions = .jobTitle
    
    var body: some View {
        
        VStack {
            HStack {
                Button {
                    withAnimation(.snappy) {
                        show = false
                        // reset search and reset filters
                        searchInput = ""
                        searchJob("")
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                if (!searchInput.isEmpty) {
                    Button {
                        searchInput = ""
                    } label: {
                        Text("Clear")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                
                if selectedOption == .jobTitle {
                    Text("Which ?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Seach jobs ...", text: $searchInput)
                            .font(.subheadline)
                            .onSubmit {
                                searchJob("job")
                                show.toggle()
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 1.0)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color(.systemGray4))
                    }
                } else {
                    CollapsedPickerView(title: "Job", description: "Search job")
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedOption = .jobTitle
                                searchInput = ""
                                searchJob("")
                            }
                            
                        }
                }
                
                
            }
            .modifier(CollapsableViewModifier())
            
            
            // location search option
            VStack(alignment: .leading) {
                
                if selectedOption == .location {
                    Text("Where ?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Seach locations ...", text: $searchInput)
                            .font(.subheadline)
                            .onSubmit {
                                searchJob("location")
                                show.toggle()
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 1.0)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color(.systemGray4))
                    }
                } else {
                    CollapsedPickerView(title: "Location", description: "Search location")
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedOption = .location
                                searchInput = ""
                                searchJob("")
                            }
                            
                        }
                }
                
            }
            .modifier(CollapsableViewModifier())
            
            
            // Employment type search option
            VStack(alignment: .leading) {
                
                if selectedOption == .employmentType {
                    Text("What ?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.small)
                        
                        TextField("Seach employment options ...", text: $searchInput)
                            .font(.subheadline)
                            .onSubmit {
                                searchJob("employment")
                                show.toggle()
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 1.0)
                            .stroke(lineWidth: 1.0)
                            .foregroundStyle(Color(.systemGray4))
                    }
                } else {
                    CollapsedPickerView(title: "Employment", description: "Search employment")
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedOption = .employmentType
                                searchInput = ""
                                searchJob("")
                            }
                        }
                }
                
            }
            .modifier(CollapsableViewModifier())
            
            Spacer()
        }
        
        
    }
}

#Preview {
    SearchView(show: .constant(false), searchInput: .constant(""), searchJob: { searchText in
      })
}

/**
 Collapsable view modifier allows multiple views to use the same modifier
 */
struct CollapsableViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(radius: 10)
    }
}

/**
 The view when the search items are collapsed
 */
struct CollapsedPickerView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack{
            // location search view
            HStack{
                Text(title)
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(description)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                
            }
        }
    }
}
