//
//  ContentView.swift
//  Instafilter
//
//  Created by Artem on 01/12/2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 1.0
    @State private var filterRadius = 100.0
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var disableSave = true
    
    
    
    @State private var showingFilterSheet = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
               
                .onTapGesture {
                    showingImagePicker = true
                }
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) {_ in applyProcessing()}
                }
                HStack{
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) {_ in applyProcessing()}
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
            .onChange(of: inputImage) {_ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
                
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystalize"){setFilter(CIFilter.crystallize())}
                Button("Edges"){setFilter(CIFilter.edges())}
                Button("Gaussian Blur"){setFilter(CIFilter.gaussianBlur())}
                Button("Pixellate"){setFilter(CIFilter.pixellate())}
                Button("Sepia Tone"){setFilter(CIFilter.sepiaTone())}
                Button("Unsharp mask"){setFilter(CIFilter.unsharpMask())}
                Button("Vignette"){setFilter(CIFilter.vignette())}
                Button("Vibrance"){setFilter(CIFilter.vibrance())}
                Button("Cancel", role: .cancel){}
            }
        }
        }
        
        func loadImage(){
            guard let inputImage = inputImage else {return}
            
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
            disableSave = false
        }
        
        func save(){
            guard let processedImage = processedImage else {return}
            let imageSaver = ImageSaver()
            
            imageSaver.succesHandler = {
                print("Success")
            }
            
            imageSaver.errorHandler = {
                print("Oops \($0.localizedDescription)")
            }
            
            imageSaver.writeToPhotoAlbum(image: processedImage)
        }
    
        
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
            
//
//            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
            
            guard let outputImage = currentFilter.outputImage else {return}
            
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let UIImage = UIImage(cgImage: cgimg)
                image = Image(uiImage: UIImage)
                
            }
        }
        
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
