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
// MARK: * Expect x Guarantee
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _  value: T.Value,
    as guarantee: T.Type,
    is expectation: Bool,
    at location: SourceLocation = #_sourceLocation
)   where T: Guarantee, T.Value: Equatable {
    
    #expect(
        T.predicate(value) == expectation,
        "Guarantee.predicate(_:)",
        sourceLocation: location
    )
    
    if  expectation {
        Ɣexpect(
            try T(value, prune: Bad.error).payload(),
            is: Result<T.Value, Bad>.success(value),
            because: "Guarantee.init(_:prune:)",
            at: location
        )
        
        #expect(
            T(unsafe: value).payload() == value,
            "Guarantee.init(unsafe:)",
            sourceLocation: location
        )
        
        #expect(
            T(value).payload() == value,
            "Guarantee.init(_:)",
            sourceLocation: location
        )
        
        #expect(
            T(unchecked: value).payload() == value,
            "Guarantee.init(unchecked:)",
            sourceLocation: location
        )

        #expect(
            T(exactly: value)?.payload() == value,
            "Guarantee.init(exactly:)",
            sourceLocation: location
        )
        
    }   else {
        #expect(T(exactly: value) == nil,
            "Guarantee.init(exactly:)",
            sourceLocation: location
        )
        
        #expect(throws: Bad.error, "Guarantee.init(_:prune:)", sourceLocation: location) {
            try T(value, prune: Bad.error)
        }
    }
}
