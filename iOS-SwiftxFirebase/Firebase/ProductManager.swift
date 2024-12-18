//
//  ProductManager.swift
//  iOS-SwiftxFirebase
//
//  Created by chris on 2024/11/28.
//

import Foundation
import FirebaseFirestore

final class ProductManager {
    static let shared = ProductManager()
    
    private init() {}
    
    private let productCollection = Firestore.firestore().collection("products")
    
    /// Returning a document from object from firestore who represents a product schema
    private func productDocument(productId: String) -> DocumentReference {
        productCollection.document(productId)
    }

    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getOneProduct(productId: String) async throws -> Product {
        let document = try await productDocument(productId: productId).getDocument(as: Product.self)
        return document
    }
    
//    private func getAllProducts() async throws -> [Product] {
//        try await productCollection.getDocumentsByType(as: Product.self)
//    }
//    
//    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
//        try await productCollection    //field in db
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocumentsByType(as: Product.self)
//    }
//    
//    private func getAllProductsForCategory(category: String) async throws -> [Product] {
//        try await productCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .getDocumentsByType(as: Product.self)
//    }
//    
//    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
//        try await productCollection    //field in db
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocumentsByType(as: Product.self)
//    }
    
    
    private func getAllProducts() -> Query {
        productCollection
    }
    
    private func getAllProductsSortedByPrice(descending: Bool) -> Query {
       productCollection    //field in db
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            
    }
    
    private func getAllProductsForCategory(category: String) -> Query {
         productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
          
    }
    
    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            
    }
    
    func getAllProductsByFilters (
        lowPrice descending: Bool?, // filter
        by category: String?, // filter
        count: Int, // pagination
        lastDocument: DocumentSnapshot? // product itself
    )
    async throws -> (
        products: [Product], // array of documents
        lastDocument: DocumentSnapshot? // last document from firebase
    ){
        var query: Query = getAllProducts()
        
        if let descending, let category { // true, true
            query = getAllProductsByPriceAndCategory(
                descending: descending,
                category: category
            )
            
        } else if let descending { // true, false
            query = getAllProductsSortedByPrice(
                descending: descending
            )
        } else if let category { // false , true
            query =  getAllProductsForCategory(
                category: category
            )
        }
        
        if let lastDocument {
            return try await query
                .limit(to: count) // how many (pagination) 10 hardcoded so far
                .start(afterDocument: lastDocument) // if pagination already started, get the next one
                .getDocumentsByTypeWithSnapshot(  // execute firestore query with all previows stuffs...
                    as: Product.self
                )
        } else {
            return try await query
                .limit(to: count) // how many (pagination) 10 hardcoded so far
                .getDocumentsByTypeWithSnapshot(  // execute firestore query with all previows stuffs...
                    as: Product.self
                )
        }
    }
    
            
    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lastDocument: DocumentSnapshot?) {
        if let lastDocument { // because 2 or more products could have same rating
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsByTypeWithSnapshot(as: Product.self)
        } else {
            return try await productCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsByTypeWithSnapshot(as: Product.self)
        }
    }
}

extension Query {
    /// This is a poweful function I just created but...
    /// Create a generic object <T> and make it decodable (because the current models (movie, product..)) are decodable
    /// So the function receive a model as generic and try to get all documents from firebase.
    /// Be careful, if the collection from db has tons of documents you will get all of them each time you use this method
    /// If that is the case please create some filters first. It takes time and costs to do it many times in a row.

//    func getDocumentsByType<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//        let snapshot = try await self.getDocuments()
//        return try snapshot.documents.map({ document in
//            return try document.data(as: T.self)
//        })
//    }
    
    func getDocumentsByType<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await self.getDocumentsByTypeWithSnapshot(as: type).products // from getDocumentsByTypeWithSnapshot(products...)
        
    }
    
    func getDocumentsByTypeWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        let document = try snapshot.documents.map({ document in
            return try document.data(as: T.self)
        })
        return (document, snapshot.documents.last)
    }
}
