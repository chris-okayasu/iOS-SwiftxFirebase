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
    @Published var selectedOption: FilterOptions? = nil
    @Published var selectedCategory: filterCategoryOption? = nil
    
    enum FilterOptions: String, CaseIterable {
        case noFilter
        case priceHigh
        case pricelow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .pricelow: return false
            }
        }
    }
    
    enum filterCategoryOption: String, CaseIterable {
        case all
        case smartphones
        case laptops
        case fragrances
        
        var categoryKey: String? {
            if self == .all { return nil }
            return self.rawValue
        }
    }

    
//    func getAllProducts() async throws { // populating the @Published product array
//        self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: nil, by: nil)
//    }
    
    
    // Query
    // Updated UI
    // Show Selected
    func filterSelectedOption(option: FilterOptions) async throws {
//        switch option {
//        case .noFilter:
//            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: nil, by: nil)
//            break
//        case .priceHigh:
//            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: true, by: nil)
//            break
//        case .pricelow:
//            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: false, by: nil)
//            break
//        }
        self.selectedOption = option
        self.getProducts()
    }
    
    func filterSelectedCategory(option: filterCategoryOption) async throws {
//        switch option {
//        case .all:
//            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: nil, by: nil)
//            break
//        case .smartphones, .laptops, .fragrances:
//            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: nil, by: option.rawValue)
//            break
//        }
        
        self.selectedCategory = option
        self.getProducts()
    }
    
    func getProducts() {
        Task{
            self.products = try await ProductManager.shared.getAllProductsByFilters(lowPrice: selectedOption?.priceDescending, by: selectedCategory?.categoryKey)
        }
       
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
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedOption?.rawValue ?? "NONE")"){
                    ForEach(ProductsViewModel.FilterOptions.allCases, id: \.self) { option in
                        Button(option.rawValue){
                            Task{
                                try await viewModel.filterSelectedOption(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Categorty: \(viewModel.selectedCategory?.rawValue ?? "NONE")"){
                    ForEach(ProductsViewModel.filterCategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue){
                            Task{
                                try await viewModel.filterSelectedCategory(option: option)
                            }
                        }
                    }
                }
            }
        })
        .onAppear{
            viewModel.getProducts()
        }
        
        //.onAppear{
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
