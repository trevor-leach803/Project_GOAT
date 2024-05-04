//
//  SubmissionsView.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/5/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import Foundation
import FirebaseFirestore

struct SubmissionsView: View {

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    @State private var listOfPrevious: [(UIImage, String, Timestamp)] = []
    @State var previousSubmissions: PreviousSubmissions = PreviousSubmissions()
    @State private var hasLoadedData: Bool = false
    @State private var isDataLoaded: Bool = false // Track if data is loaded and sorted

    var body: some View {
        ScrollView {
            if isDataLoaded { // Only display when data is loaded and sorted
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(listOfPrevious, id: \.0) { imageTuple in
                        let image = imageTuple.0
                        let prediction = imageTuple.1

                        GeometryReader { geometry in
                            NavigationLink(destination: PreviousSubMetaView(image: image, prediction: prediction), label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .background(Color.white) // Optional: Add a white background
                                    .cornerRadius(8)
                                    .clipped() // Clip the image to the frame
                            })
                        }
                        .aspectRatio(contentMode: .fit)
                    }
                }
                .padding()
                .navigationTitle("Previous Submissions")
            } else {
                ProgressView() // Display a loading indicator while data is loading
            }
        }
        .onAppear {
            if !hasLoadedData {
                previousSubmissions.getPreviousSubmissions { listOfPrevious in
                    let sortedList = listOfPrevious.sorted { (imageTuple1, imageTuple2) -> Bool in
                        let timestamp1 = imageTuple1.2
                        let timestamp2 = imageTuple2.2

                        return timestamp1.compare(timestamp2) == .orderedAscending
                    }

                    self.listOfPrevious = sortedList
                    self.isDataLoaded = true // Set data loaded flag when sorting is done
                }
                hasLoadedData.toggle()
            }
        }
    }
}

class PreviousSubmissions {
        
    func getPreviousSubmissions(completion: @escaping ([(UIImage, String, Timestamp)]) -> Void) {
        let viewModel = ImageViewModel()

        var previous: [(UIImage, String, Timestamp)] = []
        previous.removeAll()
        
        viewModel.retrievePhotos { image, pred, creationTime in
            previous.append((image, pred, creationTime))
            
            completion(previous)
        }
    }
}
