//
//  Reuseable+Extension.swift
//  WeatherApp
//
// Created by Arda Sisli on 8.10.2022.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}
