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
    
    @Published var selectedOption: FilterOptions? = nil //for price
    @Published var selectedCategory: filterCategoryOption? = nil // for category
    
    enum FilterOptions: String, CaseIterable { // price filter available, add more if needed
        case noFilter
        case priceHigh
        case pricelow
        
        var priceDescending: Bool? {
            switch self { //if no filter nil (give all the data)
            case .noFilter: return nil
            case .priceHigh: return true
            case .pricelow: return false
            }
        }
    }
    
    enum filterCategoryOption: String, CaseIterable { // add more if needed
        case all
        case smartphones
        case laptops
        case fragrances
        
        // we can filter by nothing (nil) or by any other value
        var categoryKey: String? {
            if self == .all { return nil } // if all, we do not need any filter else, filter by case.rawValue
            return self.rawValue
        }
    }
    
    // Filter by Price
    func filterSelectedOption(option: FilterOptions) async throws {
        self.selectedOption = option //selectedOption: respective enum and returns (true, false, nil)
        self.getProducts() //update view with the filters
    }
    
    // Filter by Category
    func filterSelectedCategory(option: filterCategoryOption) async throws {
        self.selectedCategory = option // selectedCategory: respective enum and return (nil or string)
        self.getProducts() //update view with the filters
    }
    
    /// This function is running by all filters
    /// so basically once a filter is selected, it will do 2 things
    /// 1- select the filter, like lowPrice eq true or category Laptop or both
    /// for each of them one the option from enum is selected it will run getProducts()
    /// Go to ProductManager to understand how is running queries
    /// if user use more than one filter this func will be executing more than one time also.
    func getProducts() {
        Task{
            self.products = try await ProductManager.shared
                .getAllProductsByFilters(
                    lowPrice: selectedOption?.priceDescending,
                    by: selectedCategory?.categoryKey
                )
        }
    }
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
            // Price filter option
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
            
            // Category filter option
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
    }
}

#Preview {
    NavigationStack{
        ProductsView()
    }
}
