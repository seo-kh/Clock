//
//  ResultBuilderTests.swift
//  StopwatchTests
//
//  Created by alphacircle on 1/23/26.
//

import Testing
import Foundation

@resultBuilder
enum SmoothieArrayBuilder {
    static func buildBlock(_ components: [Smoothie]...) -> [Smoothie] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [Smoothie]?) -> [Smoothie] {
        return component ?? []
    }
    
    static func buildExpression(_ expression: Smoothie) -> [Smoothie] {
        return [expression]
    }
    static func buildEither(first component: [Smoothie]) -> [Smoothie] {
        return component
    }
    static func buildEither(second component: [Smoothie]) -> [Smoothie] {
        return component
    }
    
    static func buildExpression(_ expression: Void) -> [Smoothie] {
        return []
    }
}

struct MeasuredIngredient {
    let name: String
    let unit: Unit
    let scale: Double
    
    init(name: String, unit: Unit = Unit(symbol: "cup"), scale: Double = 1.0) {
        self.name = name
        self.unit = unit
        self.scale = scale
    }
    
    static let orange = MeasuredIngredient(name: "orange")
    static let blueberry = MeasuredIngredient(name: "blueberry")
    static let avocado = MeasuredIngredient(name: "avocado")
    static let carrot = MeasuredIngredient(name: "carrot")
    static let mango = MeasuredIngredient(name: "mango")

    func measured(with unit: Unit) -> MeasuredIngredient {
        MeasuredIngredient(name: self.name, unit: unit, scale: self.scale)
    }
    
    func scaled(by scale: Double) -> MeasuredIngredient {
        MeasuredIngredient(name: self.name, unit: self.unit, scale: scale)
    }
}

struct Smoothie {
    let id: String
    let title: String
    let ddescription: String
    let measuredIngredients: [MeasuredIngredient]
    let hasFreeRecipe: Bool
    
}

//struct MeasuredIngredient {
//    let ingredient: Ingredient
//    let measurement: Measurement<Cup>
//}

final class Cup: Unit, @unchecked Sendable {
    
}

extension Unit {
    static var cups: Cup {
        Cup(symbol: "cups")
    }
}

extension Smoothie {
    
    @SmoothieArrayBuilder
    static func all(includingPaid: Bool = true) -> [Smoothie] {
        Smoothie(id: "berry-blue", title: "Berry Blue") {
            "Filling and refreshing, this smoothie will fill you with joy!"
            
            MeasuredIngredient.orange.measured(with: .cups).scaled(by: 1.5)
            MeasuredIngredient.blueberry.measured(with: .cups)
            MeasuredIngredient.avocado.measured(with: .cups).scaled(by: 0.2)
        }
        
        Smoothie(id: "carrot-chops", title: "Carrot Chops") {
            "Packed with vitamin A and C, Carrot chops is a great way to start your day!"
            
            MeasuredIngredient.orange.measured(with: .cups).scaled(by: 1.5)
            MeasuredIngredient.carrot.measured(with: .cups).scaled(by: 0.5)
            MeasuredIngredient.mango.measured(with: .cups).scaled(by: 0.5)
        }

        if includingPaid {
            Smoothie(id: "crazy-colada", title: "Crazy Colada") {
                "Enjoy the tropical flavor of coconut and pineapple!"
                
                MeasuredIngredient.orange.measured(with: .cups).scaled(by: 1.5)
                MeasuredIngredient.carrot.measured(with: .cups).scaled(by: 0.5)
                MeasuredIngredient.mango.measured(with: .cups).scaled(by: 0.5)
            }
        } else {
            print("Only..got free smoothies")
        }
    }
}

extension Smoothie {
    init(id: String, title: String, @SmoothieBuilder _ makeIngredients: () -> (String, [MeasuredIngredient])) {
        let (desc, ingreds) = makeIngredients()
        self.init(id: id, title: title, ddescription: desc, measuredIngredients: ingreds, hasFreeRecipe: false)
    }
}

@resultBuilder
enum SmoothieBuilder {
    static func buildBlock(_ description: String, _ components: MeasuredIngredient...) -> (String, [MeasuredIngredient]) {
        return (description, components)
    }
    
    @available(*, unavailable, message: "missing `description` field")
    static func buildBlock(_ components: MeasuredIngredient...) -> (String, [MeasuredIngredient]) {
        fatalError()
    }
}
