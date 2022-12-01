//
//  ImagePickerSwiftUI.swift
//  Instafilter
//
//  Created by Artem on 01/12/2022.
//

import SwiftUI
import PhotosUI

struct Photos: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageInput: Data? = nil
    
    var body: some View {
        PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) {newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self){
                            imageInput = data
                        }
                    }
                }
        if let imageInput, let uiImage = UIImage(data: imageInput) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}


struct Photos_Previews: PreviewProvider {
    static var previews: some View {
        Photos()
    }
}
