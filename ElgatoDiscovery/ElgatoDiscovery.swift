//
//  main.swift
//  ElgatoDiscovery
//
//  Created by Dj Walker-Morgan on 06/02/2022.
//

import Foundation
import Network

@main
struct ElgatoDiscovery {
    static func main() async throws {
        let lt=LightTracker()
        lt.start()
        print("Done")
    }
}

