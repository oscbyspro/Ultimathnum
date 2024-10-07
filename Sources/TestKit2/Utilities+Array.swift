//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit

//*============================================================================*
// MARK: * Utilities x Array
//*============================================================================*

extension Array {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(count: Int, next: () -> Element) {
        self.init()
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            self.append(next())
        }
    }
}

//*============================================================================*
// MARK: * Utilities x Array x Data Integer x Body
//*============================================================================*

extension Array where Element: SystemsIntegerWhereIsUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func random(count: Swift.Int, using randomness: inout some Randomness) -> Self {
        Self.random(count: count...count, using: &randomness)
    }
    
    @inlinable public static func random(count: ClosedRange<Swift.Int>, using randomness: inout some Randomness) -> Self {
        let range = IX(count.lowerBound)...IX(count.upperBound)
        let count = IX.random(in: range, using: &randomness)
        
        return Self(count: Swift.Int(count)) {
            Element.random(using: &randomness)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        try self.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element>.Body) throws -> T
    )   rethrows -> T {
        try self.withUnsafeMutableBufferPointer {
            try action(MutableDataInt.Body($0)!)
        }
    }
    
    @inlinable public borrowing func asBinaryIntegerBodyNormalized() -> SubSequence {
        self[...].asBinaryIntegerBodyNormalized()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Sub Sequence
//=----------------------------------------------------------------------------=

extension ArraySlice where Element: SystemsIntegerWhereIsUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element>.Body) throws -> T
    )   rethrows -> T where Self == Array<Element>.SubSequence {
        try self.withUnsafeBufferPointer {
            try action(DataInt.Body($0)!)
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element>.Body) throws -> T
    )   rethrows -> T where Self == Array<Element>.SubSequence {
        try self.withUnsafeMutableBufferPointer {
            try action(MutableDataInt.Body($0)!)
        }
    }
    
    @inlinable public consuming func asBinaryIntegerBodyNormalized() -> SubSequence {
        while self.last == 0 { self.removeLast() }; return self
    }
}
