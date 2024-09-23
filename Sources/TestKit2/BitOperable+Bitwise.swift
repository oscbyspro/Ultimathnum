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
// MARK: * Bitwise
//*============================================================================*

@inlinable public func expect<T>(
    not instance: T, is expectation: T, sourceLocation: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(~instance == expectation, "BitOperable.~(_:)", sourceLocation: sourceLocation)
    #expect( instance.toggled() == expectation, "BitOperable/toggled()", sourceLocation: sourceLocation)
    #expect({ var x = instance; x.toggle(); return x }() == expectation, "BitOperable/toggle()", sourceLocation: sourceLocation)
}

@inlinable public func expect<T>(
    _ lhs: T, and rhs: T, is expectation: T, sourceLocation: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs & rhs == expectation, "BitOperable.&(_:_:)", sourceLocation: sourceLocation)
    #expect({ var x = lhs; x &= rhs; return x }() == expectation, "BitOperable/&=(_:)", sourceLocation: sourceLocation)
}

@inlinable public func expect<T>(
    _ lhs: T, or rhs: T, is expectation: T, sourceLocation: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs | rhs == expectation, "BitOperable.|(_:_:)", sourceLocation: sourceLocation)
    #expect({ var x = lhs; x |= rhs; return x }() == expectation, "BitOperable/|=(_:)", sourceLocation: sourceLocation)
}

@inlinable public func expect<T>(
    _ lhs: T, xor rhs: T, is expectation: T, sourceLocation: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs ^ rhs == expectation, "BitOperable.^(_:_:)", sourceLocation: sourceLocation)
    #expect({ var x = lhs; x ^= rhs; return x }() == expectation, "BitOperable/^=(_:)", sourceLocation: sourceLocation)
}
