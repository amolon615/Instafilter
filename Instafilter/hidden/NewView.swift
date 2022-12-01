////
////  NewView.swift
////  Instafilter
////
////  Created by Artem on 01/12/2022.
////
//
//import SwiftUI
//
//
//
//
//struct NewView: View {
//    @State private var image: Image?
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    
//    var body: some View {
//        VStack{
//            image?
//                .resizable()
//                .scaledToFit()
//            Button("select image"){
//                showingImagePicker = true
//            }
//            Button("save image") {
//                guard let inputImage = inputImage else {return}
//                let imageSaver = ImageSaver()
//                imageSaver.writeToPhotoAlbum(image: inputImage)
//            }
//        }
//        .sheet(isPresented: $showingImagePicker) {
//            ImagePicker(image: $inputImage)
//        }
//        .onChange(of: inputImage) { _ in
//            loadImage()
//        }
//    }
//    
//    func loadImage() {
//        guard let inputImage = inputImage else {return}
//        image = Image(uiImage: inputImage)
// 
//        
//    }
//}
//
//struct NewView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewView()
//    }
//}
