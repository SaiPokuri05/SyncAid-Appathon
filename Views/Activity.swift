//
//  Activity.swift
//  SyncAid
//
//  Created by Sai Akshita Pokuri on 11/4/24.
//
// Activity.swift

import UIKit

struct Activity {
    let name: String
    let url: URL?
    let image: UIImage? // Use UIImage for UIKit compatibility

    init(name: String, url: URL? = nil, image: UIImage? = nil) {
        self.name = name
        self.url = url
        self.image = image
    }
}

