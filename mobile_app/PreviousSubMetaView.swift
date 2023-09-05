//
//  PreviousSubMetaView.swift
//  Project_GOAT
//
//  Created by Trevor Leach on 8/6/23.
//

import SwiftUI

struct PreviousSubMetaView: View {
    var image: UIImage
    var prediction: String
    
    var body: some View {
        VStack {
            Text(prediction)
                .font(.largeTitle)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
    }
}

