//
//  Box.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

class Box<T> {
    typealias Listener = (T) -> Void

    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
