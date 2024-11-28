//
//  ProductPreviewView.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/28.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            if let thumbnailURL = product.thumbnail, let url = URL(string: thumbnailURL) {
                AsyncImage(url: url) { image in
                    switch image {
                    case .empty:
                        ProgressView()
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.4), radius: 4, x: 0, y: 2)
                    case .failure:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
            } else {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading, spacing: 4){
                Text(product.brand ?? "N/A")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.primary)
                Text("Product: " + (product.title ?? "N/A"))
                    .font(.title3)
                
                Text("Price: ¥"+String(product.price ?? 0))
                Text("Rating: "+String(product.rating ?? 0))
                Text("Category: "+(product.category ?? "N/A"))
                    .font(.caption)
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProductCellView(
        product: Product(
            id: 3423,
            title: "test title",
            description: "test description",
            price: 9,
            discountPercentage: 0,
            rating: 5,
            stock: 10,
            brand: "test brand",
            category: "test category",
            thumbnail: "https://media.revistagq.com/photos/5e4d03617134d9000847ff44/1:1/w_500,h_500,c_limit/iphone-9.pngx",
            images: []
        )
    )
}
