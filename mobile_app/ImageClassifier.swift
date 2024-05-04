//
//  ImageClassifier.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/3/23.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    @Published var classificationResults: [String] = []
    
    var imageClass: [String] {
        classifier.results!
    }
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
        self.classificationResults = imageClass
    }
        
}
