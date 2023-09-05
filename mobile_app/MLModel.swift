//
//  MLModel.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/3/23.
//

import CoreML
import Vision
import CoreImage

class Classifier {
    
    private(set) var results: [String]?
    
    func detect(ciImage: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Project_GOAT_ML_Model_2(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        
        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        var outcome: [String] = []
        
        for observation in results {
            var className: String = ""
            if observation.identifier == "billy-images" {
                className = "Billy"
            } else {
                className = "Not a Billy"
            }

            let confidence = String(format: "%.2f", observation.confidence * 100)
            outcome.append("\(className) - \(confidence)%")
        }
        print(outcome)
        self.results = outcome
        
    }
}
        

