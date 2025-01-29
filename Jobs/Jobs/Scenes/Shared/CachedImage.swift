//
//  CachedImage.swift
//  Jobs
//
//  Created by Rui Silva on 29/01/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CachedImage: View {
    
    let url: String
    let defaultLogoSize: Double
    
    var body: some View {
        WebImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } placeholder: {
            defaultImage
        }
    }
    
    private var defaultImage: some View {
        ZStack {
            Color.white
                .frame(width: defaultLogoSize, height: defaultLogoSize)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            Image(systemName: "suitcase")
                .resizable()
                .foregroundColor(.mint)
                .opacity(0.3)
                .frame(width: 42, height: 38)
        }
    }
}
