//
//  UserlistViewModel.swift
//  AssignmentDemoTest
//
//  Created by akash dhomne on 14/06/23.
//

import UIKit
import CoreData

protocol UserViewModelProtocol {
    
    var usersDidChanges: ((Bool, Bool) -> Void)? { get set }
    
    func fetchUserList()
}
class UserlistViewModel: UserViewModelProtocol {

    //MARK: - Internal Properties
    
    var usersDidChanges: ((Bool, Bool) -> Void)?
    
    var users: [Resultvalue]? {
        didSet {
            self.usersDidChanges!(true, false)
        }
    }
    
    func fetchUserList() {
        self.users = [Resultvalue]()
        if ConnectionCheck.isConnectedToNetwork() {
            UsersApiServices.instance.fetchMovies { result in
                switch result {
                case .success(let data):
                    let mappedModel = try? JSONDecoder().decode(User.self, from: data) as User
                    self.users = mappedModel?.results ?? []
                    break
                case .failure(let error):
                    print(error.description)
                    
                }
            }
        }
        else{
        }
        
  
    }
}

