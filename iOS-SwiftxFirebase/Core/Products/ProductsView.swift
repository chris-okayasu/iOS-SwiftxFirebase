//
//  Products.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/28.
//

import SwiftUI


@MainActor
final class ProductsViewModel: ObservableObject{
    
    @Published private(set) var products: [Product] = []
    
    func getAllProducts() async throws { // populating the @Published product array
        self.products = try await ProductManager.shared.getAllProducts()
    }
    
    // NOT NEEDED
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
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductCellView(product: product)
            }
        }

        .navigationTitle("Products")
        .task{
            try? await viewModel.getAllProducts()
        }
        
        //        .onAppear{
        //            Task{
        //                try await downloadProductsAndUploadToFirebase()
        //            }
        //        }
        
    }
    
}

#Preview {
    NavigationStack{
        ProductsView()
    }
}
