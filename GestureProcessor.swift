//import SwiftUI
//
//import AVFoundation
//import Vision
//
//class GestureProcessor {
//    private var analysisRequests = [VNRequest]()
//    private let sequenceHandler = VNSequenceRequestHandler()
//    
//    init() {
//        setupVision()
//    }
//    
//    private func setupVision() {
//        // Assuming `GestureRecognitionModel` is your Core ML model.
//        guard let model = try? VNCoreMLModel(for: GestureRecognitionModel().model) else { return }
//        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//            self?.handleGestureRecognition(request: request, error: error)
//        }
//        analysisRequests.append(request)
//    }
//    
//    func processCurrentFrame(pixelBuffer: CVPixelBuffer) {
//        do {
//            try sequenceHandler.perform(analysisRequests, on: pixelBuffer)
//        } catch {
//            print("Error processing frame: \(error.localizedDescription)")
//        }
//    }
//    
//    private func handleGestureRecognition(request: VNRequest, error: Error?) {
//        guard let results = request.results as? [VNClassificationObservation] else { return }
//        if let topResult = results.first {
//            // Here you would check the identifier and trigger the game's cooperate or defect action.
//        }
//    }
//}
