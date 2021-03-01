//
//  ArrayUtils.swift
//  ECG Scanner
//
//  Created by Paco Gago on 08/07/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

protocol ArrayUtils {
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T
}

class ArrayUtilsImpl: ArrayUtils{
    
    //input: array
    //return: array sin elemento repetidos
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
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
