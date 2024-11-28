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
    
    func getAllProducts() async throws -> [Product] {
        try await productCollection.getDocumentsByType(as: Product.self)
    }
}

extension Query {
    /// This is a poweful functions I just created but...
    /// Create a generic object <T> and make it decodable (because the current models (movie, product..)) are decodable
    /// So the function receive a model as generic and try to get all documents from firebase.
    /// Be careful, if the collection from db has tons of documents you will get all of them each time you use this method
    /// If that is the case please create some filters first. It takes time and costs to do it many times in a row.
    func getDocumentsByType<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map({ document in
            return try document.data(as: T.self)
        })
    }
}
