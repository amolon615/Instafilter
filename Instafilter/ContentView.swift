//
//  ContentView.swift
//  Instafilter
//
//  Created by Artem on 01/12/2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    
    //our main image variable, which stores everything
    //later on we have to convert selected image from Picker to the same type
    //to oparate with it
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var disableSave = true
    
    //Swift doesn't allow us to save selected image to Image
    //so we have to store it in Data type, then unwrap it, then convert it to UIImage
    @State private var selectedImage: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    
    
    @State private var showingFilterSheet = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    var body: some View {
        NavigationView{
            VStack{
                //calling PhotoPicker
                PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                //checking selected image in our picker
                        .onChange(of: selectedItem) {newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self){
                                  selectedImage = data
                                }
                            }
                        }
                //unwraping data type and converting it to UIImage type
                if let selectedImage,
                    let inputImage = UIImage(data: selectedImage) {
                 
                  //  Image(uiImage: inputImage)
                    image?
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .onChange(of: inputImage) { _ in loadImage() }
                 
                }
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) {_ in applyProcessing()}
                }
            
                .padding(.vertical)
                
                HStack{
                    Button("Change filter"){
                        showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save picture", action: save)
                        .disabled(disableSave)
                        
                }
             
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystalize"){
                    setFilter(CIFilter.crystallize())
                    print("selected crystylize")
                }
                Button("Edges"){
                    setFilter(CIFilter.edges())
                    print("selected edges")
                }
                Button("Gaussian Blur"){
                    setFilter(CIFilter.gaussianBlur())
                    print("selected gaussian blur")
                }
                Button("Pixellate"){
                    setFilter(CIFilter.pixellate())
                    print("selected pixellate")
                }
                Button("Sepia Tone"){
                    setFilter(CIFilter.sepiaTone())
                    print("selected sepia tone")
                }
                Button("Unsharp mask"){
                    setFilter(CIFilter.unsharpMask())
                    print("selected unsharp mask")
                }
                Button("Vignette"){
                    setFilter(CIFilter.vignette())
                    print("selected vignette")
                }
                Button("Vibrance"){
                    setFilter(CIFilter.vibrance())
                    print("selected vibrance")
                }
                Button("Cancel", role: .cancel){
                    print("choice canceled")
                }
            }
        }
        }
        
        func loadImage(){
            guard let unwrappedData = selectedImage else {return}
            inputImage = UIImage(data: unwrappedData)
            
            guard let inputImage = inputImage else {return}
             let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
            disableSave = false
            print("image loaded")
        }
        
    
        func save(){
            guard let processedImage = processedImage else {return}
            let imageSaver = processedImage
            UIImageWriteToSavedPhotosAlbum(imageSaver, nil, nil, nil)
            print("image saved")
        }
    
    
    //applying processing
        
        func applyProcessing(){
            let inputKeys = currentFilter.inputKeys
            
            if inputKeys.contains(kCIInputIntensityKey) {
                currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            }
            
            if inputKeys.contains(kCIInputRadiusKey) {
                currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
            }
            if inputKeys.contains(kCIInputScaleKey) {
                currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
            }
            
            
            guard let outputImage = currentFilter.outputImage else {return}
            
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let UIImage = UIImage(cgImage: cgimg)
                
                //image is an entity which is displaying all the changes on the screen (loaded image + image with processed filters)
                image = Image(uiImage: UIImage)
                
                //processedImage is prepared for saving to the library
                processedImage = UIImage
                
            }
        }
        
    
    //setting filter
        func setFilter(_ filter: CIFilter) {
            currentFilter =  filter
            loadImage()
            applyProcessing()
            
        }
    
    
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
