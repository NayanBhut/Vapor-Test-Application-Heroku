//
//  ProductController.swift
//  
//
//  Created by Nayan Bhut on 8/14/22.
//

import Foundation
import Vapor
import Fluent

class ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let protected = routes.grouped(UserAuthenticator())
        protected.get("products",use: getProducts)
        protected.post("products",use: addProduct)
        protected.group(":id") { todo in
            protected.delete(use: getProduct)
        }
    }
    
    func getProducts(req: Request) async throws -> ResponseModel<[ProductModel]>{
        try req.auth.require(UsersData.self)
        let productsData = try await ProductModel.query(on: req.db).all()
        return ResponseModel(data: productsData, status: true,message: productsData.count == 0 ? "No Products Fount" : nil)
    }
    
    func addProduct(req: Request) async throws -> ResponseModel<ProductModel> {
        try req.auth.require(UsersData.self)
        try ProductModel.validate(content: req)
        let productData = try req.content.decode(ProductModel.self)
        print(productData)
        productData.id = UUID()
        
        if productData.name == "" {
            return ResponseModel(data: nil, status: false,message: "Please add product name")
        }
        
        try await productData.save(on: req.db)
        return ResponseModel(data: productData, status: true,message: "Product added successfully")
    }
    
    func searchProduct(req: Request) async throws -> ResponseModel<ProductModel> {
        try ProductModel.validate(content: req)
        let productData = try req.content.decode(ProductModel.self)
        print(productData)
        productData.id = UUID()
        
        if productData.name == "" {
            return ResponseModel(data: nil, status: false,message: "Please add product name")
        }
        
        try await productData.save(on: req.db)
        return ResponseModel(data: productData, status: true,message: "Product added successfully")
    }
    
    func getProduct(req: Request) async throws -> ResponseModel<ProductModel> {
        guard let product = try await ProductModel.find(req.parameters.get("id"), on: req.db) else {
            return ResponseModel(data: nil, status: false,message: "Product not found.")
        }
        return ResponseModel(data: product, status: false,message: "Product found successfully")
    }
}
