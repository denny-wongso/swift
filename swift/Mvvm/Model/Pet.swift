//
//  Pet.swift
//  swift
//
//  Created by Denny Wongso on 26/12/22.
//

import Foundation

public class Pet {
    public enum Gender: String {
        case Male
        case Female
    }
    
    public enum PetType: String {
        case Dog
        case Cat
        case Bird
        case Fish
    }
    public let name: String
    public let age: Int
    public let gender: Gender
    public let friendliness: Double
    public let type: PetType
    
    init(name: String, age: Int, gender: Gender, friendliness: Double, type: PetType) {
        self.name = name
        self.age = age
        self.gender = gender
        self.friendliness = friendliness
        self.type = type
    }
}
