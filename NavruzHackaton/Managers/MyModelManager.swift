//
//  MyModelManager.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//

import CoreML
import UIKit

class MyModelManager: ObservableObject {
    let model: MLModel
    @Published var predictionPercentage: Double = 0.0

    init() {
        guard let modelURL = Bundle.main.url(forResource: "model", withExtension: "mlmodelc") else {
            fatalError("Could not find compiled model file.")
        }
        do {
            model = try MLModel(contentsOf: modelURL)
        } catch {
            fatalError("Error loading model: \(error)")
        }
    }
    
    func predict(input: CVPixelBuffer) {
        do {
            // Create a feature provider with the proper input key.
            let inputProvider = try MLDictionaryFeatureProvider(dictionary: ["image": MLFeatureValue(pixelBuffer: input)])
            let predictionOutput = try model.prediction(from: inputProvider)
            // Assume your model outputs a percentage (Double) for key "output"
            if let percentage = predictionOutput.featureValue(for: "output")?.doubleValue {
                DispatchQueue.main.async {
                    self.predictionPercentage = percentage
                }
            }
        } catch {
            print("Prediction error: \(error)")
        }
    }
}
