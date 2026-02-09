//
//  HTMLNode.swift
//  StopwatchTests
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

struct HTMLNode {
    let tag: String
    let attributes: [String: String]
    let childern: [HTMLNode]
    let content: String?
    
    init(tag: String, attributes: [String : String] = [:], childern: [HTMLNode] = [], content: String? = nil) {
        self.tag = tag
        self.attributes = attributes
        self.childern = childern
        self.content = content
    }
    
    func render() -> String {
        let attributeString = attributes
            .map({ "\($0.key)=\"\($0.value)\""})
            .joined(separator: " ")
        let openTag = attributeString.isEmpty ? "<\(tag)>" : "<\(tag) \(attributeString)>"
        
        if let content {
            return "\(openTag)\(content)</\(tag)>"
        }
        
        let childrenHTML = childern.map({ $0.render() }).joined()
        return "\(openTag)\(childrenHTML)</\(tag)>"
    }
}
