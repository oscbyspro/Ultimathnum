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
// MARK: * Comparison
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _      lhs: T,
    equals rhs: T,
    is     expectation: Signum =  .zero,
    using  strategy: ID.Comparable.Type = ID.Comparable.self,
    at     location: SourceLocation = #_sourceLocation
)   where  T: Comparable {
    
    #expect((lhs <  rhs) == (expectation == Signum.negative), "Comparable.< (_:_:)", sourceLocation: location)
    #expect((lhs >= rhs) == (expectation != Signum.negative), "Comparable.>=(_:_:)", sourceLocation: location)
    #expect((lhs >  rhs) == (expectation == Signum.positive), "Comparable.> (_:_:)", sourceLocation: location)
    #expect((lhs <= rhs) == (expectation != Signum.positive), "Comparable.<=(_:_:)", sourceLocation: location)
    
    Ɣexpect(lhs, equals: rhs, is: expectation.isZero, using: ID.Equatable.self, at: location)
}

@inlinable public func Ɣexpect<T>(
    _      lhs: T,
    equals rhs: T,
    is     expectation: Bool = true,
    using  strategy: ID.Equatable.Type = ID.Equatable.self,
    at     location: SourceLocation = #_sourceLocation
)   where  T: Equatable {
    
    #expect((lhs == rhs) ==  expectation, "Equatable.==(_:_:)", sourceLocation: location)
    #expect((lhs != rhs) == !expectation, "Equatable.!=(_:_:)", sourceLocation: location)
    
    if  expectation, let lhs = lhs as? any Hashable, let rhs = rhs as? any Hashable {
        #expect(lhs.hashValue == rhs.hashValue, "Hashable/hashValue", sourceLocation: location)
    }
}
