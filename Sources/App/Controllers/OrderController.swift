//
//  File.swift
//  
//
//  Created by Nayan Bhut on 3/5/23.
//

import Vapor

struct OrderController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let protected = routes.grouped(UserAuthenticator())
        let orderGroup = protected.grouped("orders")
        orderGroup.post(use: placeOrder)
    }
    
    
    func placeOrder(req: Request) async throws -> ResponseModel<OrderResponse> {
        try req.auth.require(UsersData.self)
        let createOrderModel = try req.content.decode(CreateOrder.self)
        print(createOrderModel)
        
        
        guard let productId = createOrderModel.product_id, let productId = UUID(uuidString: productId), let quantity = Int(createOrderModel.quantity ?? "0"), let customerId = createOrderModel.customer_id, let id = UUID(uuidString: customerId) else {
            return ResponseModel(data: nil, status: false,message: "Please add valid order information.")
        }
        
        let orderProductModelId = UUID()
        
        let orderModel = OrderModel(id:orderProductModelId, date: Date(), customerId: id)
        
        do {
            try await orderModel.save(on: req.db)
            
        }catch {
            print(error.localizedDescription)
            return ResponseModel(data: nil, status: false,message: "Not Able to Create Order")
        }
        
        let orderUUID = UUID()
        let orderProductModel = OrderProductModel(id:orderUUID, orderId: orderProductModelId, productId: productId, quantity: quantity)
        do {
            try await orderProductModel.save(on: req.db)
        }catch {
            print(error.localizedDescription)
            try await orderModel.delete(on: req.db)
            return ResponseModel(data: nil, status: false,message: "Not Able to Product Order")
        }
        
        let response = OrderResponse(orderId: orderUUID.uuidString)
        return ResponseModel(data: response, status: true,message: "Order Created Successfully.")
    }
}


