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
    
    private func productDocument(productId: String) -> DocumentReference {
        productCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
}
