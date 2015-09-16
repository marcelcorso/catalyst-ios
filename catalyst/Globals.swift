//
//  Globals.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import Foundation

let firebaseURL = "https://catalysttv.firebaseio.com"

extension Array {
    
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

}