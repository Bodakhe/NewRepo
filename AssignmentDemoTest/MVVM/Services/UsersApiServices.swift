//
//  UsersApiServices.swift
//  AssignmentDemoTest
//
//  Created by akash dhomne on 14/06/23.
//

import Foundation
import UIKit

class UsersApiServices: NSObject, Requestable {

    static let instance = UsersApiServices()
    
    func fetchMovies(callback: @escaping Handler) {
        
        request(method: .get, url: Domain.baseUrl()) { (result) in
            
           callback(result)
        }
        
    }
    
}
