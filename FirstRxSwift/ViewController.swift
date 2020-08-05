//
//  ViewController.swift
//  RxSwift
//
//  Created by gibntn on 5/8/2563 BE.
//  Copyright © 2563 nattanat. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

struct User: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class ViewController: UIViewController {
    let url = "https://jsonplaceholder.typicode.com/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData().subscribe(onNext: { result in
            print(result)
        }, onError: { Error in
            print(Error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }
        
    }
    
    func getUserData() -> Observable<String> {
        return Observable.create { observer in
        
            guard let url = URL(string: self.url) else {
                return Disposables.create()
            }
            
            AF.request(url).response { data in
                guard let result = data.data else {
                    return
                }
                observer.onNext(String.init(data: result, encoding: .utf8) ?? "")
                observer.onCompleted()
//                self.tranformData(response: data)
            }
            return Disposables.create()
        }
    }
    
    func tranformData(response: AFDataResponse<Data?>) {
        DispatchQueue.main.async {
            if let unwrappedData = response.data,
                let user = try? JSONDecoder().decode([User].self, from: unwrappedData) {
                print(user)
            }
        }
    }
    
}

