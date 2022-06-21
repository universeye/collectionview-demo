//
//  AsyncAwaitPrac.swift
//  collectionViewDemo
//
//  Created by Terry Kuo on 2022/6/20.
//

import UIKit

class AsyncAwaitPrac {
    
    static let shared = AsyncAwaitPrac()
    private init() {}
    func fetchImages() async throws -> [UIImage] {
        // .. perform data request
        
        return [UIImage()]
    }
}
