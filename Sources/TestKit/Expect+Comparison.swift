//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Expect x Comparison
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _      lhs: T,
    equals rhs: T,
    is     expectation: Signum = .zero,
    at     location: SourceLocation = #_sourceLocation
)   where  T: Comparable {
    
    #expect((lhs <  rhs) == (expectation == Signum.negative), sourceLocation: location)
    #expect((lhs >= rhs) == (expectation != Signum.negative), sourceLocation: location)
    #expect((lhs >  rhs) == (expectation == Signum.positive), sourceLocation: location)
    #expect((lhs <= rhs) == (expectation != Signum.positive), sourceLocation: location)
    
    Ɣexpect(lhs, equals: rhs, is: expectation.isZero, at: location)
}

@inlinable public func Ɣexpect<T>(
    _      lhs: T,
    equals rhs: T,
    is     expectation: Bool =  true,
    at     location: SourceLocation = #_sourceLocation
)   where  T: Equatable {
    
    #expect((lhs == rhs) ==  expectation, sourceLocation: location)
    #expect((lhs != rhs) == !expectation, sourceLocation: location)
    
    invariant: if expectation {
        guard let lhs = lhs as? any Hashable else { break invariant }
        guard let rhs = rhs as? any Hashable else { break invariant }
        #expect(lhs.hashValue == rhs.hashValue, sourceLocation: location)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Memory Layout
//=----------------------------------------------------------------------------=

@inlinable public func Ɣexpect<T, U>(
    _      lhs: MemoryLayout<T>.Type,
    equals rhs: MemoryLayout<U>.Type,
    at     location: SourceLocation = #_sourceLocation
) {
    
    #expect(lhs.size      == rhs.size,      sourceLocation: location)
    #expect(lhs.stride    == rhs.stride,    sourceLocation: location)
    #expect(lhs.alignment == rhs.alignment, sourceLocation: location)
}
