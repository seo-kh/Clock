//
//  HTMLHelpers.swift
//  StopwatchTests
//
//  Created by alphacircle on 2/6/26.
//

import Foundation

func html(@HTMLBuilder content: () -> [HTMLNode]) -> HTMLNode {
    HTMLNode(tag: "html", childern: content())
}

func head(@HTMLBuilder content: () -> [HTMLNode]) -> HTMLNode {
    HTMLNode(tag: "head", childern: content())
}

func body(@HTMLBuilder content: () -> [HTMLNode]) -> HTMLNode {
    HTMLNode(tag: "body", childern: content())
}

func div(class: String? = nil, id: String? = nil, @HTMLBuilder content: () -> [HTMLNode]) -> HTMLNode {
    var attributes = [String: String]()
    if let className = `class` { attributes["class"] = className }
    if let id { attributes["id"] = id }
    return HTMLNode(tag: "div", attributes: attributes, childern: content())
}

func p(_ text: String) -> HTMLNode {
    HTMLNode(tag: "p", content: text)
}

func h1(_ text: String) -> HTMLNode {
    HTMLNode(tag: "h1", content: text)
}

func ul(@HTMLBuilder content: () -> [HTMLNode]) -> HTMLNode {
    HTMLNode(tag: "ul", childern: content())
}

func li(_ text: String) -> HTMLNode {
    HTMLNode(tag: "li", content: text)
}
