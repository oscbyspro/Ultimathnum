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
    if success: Bool,
    at location: SourceLocation = #_sourceLocation
)   where T: Equatable & Guarantee {
    
    #expect(
        T.predicate(value) == success,
        "Guarantee.predicate(_:)",
        sourceLocation: location
    )
    
    if (success) {
        let expectation = T(unsafe: value)
        
        Ɣexpect(
            try T(value, prune: Bad.error),
            is: Result<T, Bad>.success(expectation),
            because: "Guarantee.init(_:prune:)",
            at: location
        )
        
        #expect(
            T(unsafe: value) == expectation,
            "Guarantee.init(unsafe:)",
            sourceLocation: location
        )
        
        #expect(
            T(value) == expectation,
            "Guarantee.init(_:)",
            sourceLocation: location
        )
        
        #expect(
            T(unchecked: value) == expectation,
            "Guarantee.init(unchecked:)",
            sourceLocation: location
        )

        #expect(
            T(exactly: value) == expectation,
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
