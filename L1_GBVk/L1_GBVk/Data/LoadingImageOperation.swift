//
//  LoadingImageOperation.swift
//  L1_GBVk
//
//  Created by Andrew on 25/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class LoadImageOperation: Operation {
    
    var url: URL?
    
    var completion: ((UIImage) -> ())?
    override func main() {
        if let data = try? Data(contentsOf: self.url!),
            let image = UIImage(data: data) {
            DispatchQueue.main.async { self.completion?(image) }
        }
        else {
            print("error")
        }
    }
}
