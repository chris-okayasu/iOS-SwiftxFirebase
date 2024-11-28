//
//  Products.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/28.
//

import SwiftUI


@MainActor
final class ProductsViewModel: ObservableObject{
    
    
    
    //    func downloadProductsAndUploadToFirebase() {
    //        guard let url = URL(string: "https://dummyjson.com/products") else { return }
    //
    //        Task {
    //            do {
    //                let (data, _) = try await URLSession.shared.data(from: url)
    //                let products = try JSONDecoder().decode(ProductArray.self, from: data)
    //                let productArray = products.products
    //
    //                for product in productArray {
    //                    try? await ProductsManager.shared.uploadProduct(product: product)
    //                }
    //
    //                print("SUCCESS")
    //                print(products.products.count)
    //            } catch {
    //                print(error)
    //            }
    //        }
    //    }
    
}


struct ProductsView: View {
    @StateObject private var productsViewModel = ProductsViewModel()
    var body: some View {
        ZStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle(
            "Products"
        )
        
        .onAppear{
            Task{
//                try await downloadProductsAndUploadToFirebase()
            }
        }
    }
    
}

#Preview {
    NavigationStack{
        ProductsView()
    }
}
