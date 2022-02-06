//
//  LightTracker.swift
//  ElgatoDiscovery
//
//  Created by Dj Walker-Morgan on 06/02/2022.
//

import Foundation
import Network


class LightTracker {
    
    var lights:[RestLight]=[]
    
    init() {
    }
    
    func start() {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        let browser = NWBrowser(for: .bonjour(type: "_elg._tcp", domain: nil), using: parameters)
        browser.stateUpdateHandler = { newState in
        }
        browser.browseResultsChangedHandler = { results, changes in
            for result in results {
                if case NWEndpoint.service = result.endpoint {
                    let light=RestLight(endpoint: result.endpoint)
                    self.lights.append(light)
                    light.getStats()
                }
            }
        }
        browser.start(queue: DispatchQueue.global())
        sleep(5)
    }
}

class RestLight:Identifiable,CustomStringConvertible {
    
    let endpoint: NWEndpoint
    let name: String
    let description: String
    
    init(endpoint: NWEndpoint) {
        self.endpoint=endpoint
        self.name=String(describing:endpoint)
        self.description=self.name
    }
    
    func getStats()
    {
        let params = NWParameters.tcp
        let stack = params.defaultProtocolStack.internetProtocol! as! NWProtocolIP.Options
        stack.version = .v4
        let connection = NWConnection(to: endpoint, using: params)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                if let innerEndpoint = connection.currentPath?.remoteEndpoint,
                   case .hostPort(let host, let port) = innerEndpoint {
                    let ipv4hostparts=String(describing:host).components(separatedBy:"%")
                    let ipv4host=ipv4hostparts[0]
                    
                    print("\(ipv4host):\(port)")
            }
            default:
                break
            }
        }
        connection.start(queue: .global())
    }
    
   
}
