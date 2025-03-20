//
//  AddTrashBinView.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 20/03/25.
//

import SwiftUI
import MapKit

struct AddTrashBinView: View {
    @StateObject private var vm = AddTrashBinViewModel()
    @StateObject private var modelManager = MyModelManager()
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var address = ""
    @State private var showingMap = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var selectedCategory: BinCategory?
    @State private var showingResultAlert = false
    @State private var resultAlertTitle = ""
    @State private var resultAlertMessage = ""
    @State private var isSuccessful = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 250)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            
                            Text("Tap to add photo")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Take a clear photo of the trash bin")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingCamera = true
                }
                .sheet(isPresented: $showingCamera) {
                    ImagePicker(image: $selectedImage, sourceType: .camera)
                        .background(Color.black.ignoresSafeArea(edges:.bottom))
                }
                
                // Category selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vm.categories) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory?.id == category.id
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                
                // Address input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        TextField("Address", text: $address)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button(action: {
                            // Implement address auto-fill
                        }) {
                            Image(systemName: "location.fill")
                                .padding(12)
                                .background(Circle().fill(Color.blue))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                // Map view
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Location")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ZStack(alignment: .bottomTrailing) {
                        Map(coordinateRegion: $region)
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                        Button(action: {
                            showingMap = true
                        }) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .padding(12)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.blue)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                        }
                        .padding(12)
                    }
                }
                
                // Submit button
                SumbitButton()
            }
            .padding()
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage, let pixelBuffer = image.toCVPixelBuffer() {
                modelManager.predict(input: pixelBuffer)
            }
        }
        .task {
            await vm.fetchCategories()
        }
        .sheet(isPresented: $showingMap) {
            FullMapView(region: $region)
        }
        .navigationTitle("Add New Trash Bin")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                }
                .padding()
            }
        })
    }
    
    
    
    
    @ViewBuilder private func SumbitButton() -> some View {
        VStack {
            Button(action: {
                if modelManager.predictionPercentage >= 75 {
                    resultAlertTitle = "Trash Bin Detected"
                    resultAlertMessage = "Trash bin found with \(modelManager.predictionPercentage)% confidence. Accepting and dismissing."
                    isSuccessful = true
                } else {
                    resultAlertTitle = "Error"
                    resultAlertMessage = "Trash bin not found in the image."
                    isSuccessful = false
                }
                showingResultAlert = true
            }) {
                Text("Add Trash Bin")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 8)
            .disabled(selectedImage == nil || selectedCategory == nil || address.isEmpty)
            .opacity((selectedImage == nil || selectedCategory == nil || address.isEmpty) ? 0.6 : 1)
        }
        }
}




















struct CategoryButton: View {
    let category: BinCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    )
                
                Text(category.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .primary)
                    .lineLimit(1)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
    }
}

struct FullMapView: View {
    @Binding var region: MKCoordinateRegion
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                        .shadow(radius: 3)
                        .offset(y: -20)
                )
                .navigationTitle("Select Location")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Confirm") {
                            dismiss()
                        }
                        .fontWeight(.bold)
                    }
                }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }
    }
}


#Preview {
    AddTrashBinView()
}
