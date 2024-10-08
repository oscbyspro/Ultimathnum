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
// MARK: * Expect x Bitwise
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    not instance: T,
    is  expectation: T,
    at  location: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(~instance == expectation, "BitOperable.~(_:)", sourceLocation: location)
    #expect( instance.toggled() == expectation, "BitOperable/toggled()", sourceLocation: location)
    #expect({ var x = instance; x.toggle(); return x }() == expectation, "BitOperable/toggle()", sourceLocation: location)
}

@inlinable public func Ɣexpect<T>(
    _   lhs: T,
    and rhs: T,
    is  expectation: T,
    at  location: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs & rhs == expectation, "BitOperable.&(_:_:)", sourceLocation: location)
    #expect({ var x = lhs; x &= rhs; return x }() == expectation, "BitOperable.&=(_:_:)", sourceLocation: location)
}

@inlinable public func Ɣexpect<T>(
    _   lhs: T,
    or  rhs: T,
    is  expectation: T,
    at  location: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs | rhs == expectation, "BitOperable.|(_:_:)", sourceLocation: location)
    #expect({ var x = lhs; x |= rhs; return x }() == expectation, "BitOperable.|=(_:_:)", sourceLocation: location)
}

@inlinable public func Ɣexpect<T>(
    _   lhs: T,
    xor rhs: T,
    is  expectation: T,
    at  location: SourceLocation = #_sourceLocation
)   where T: BitOperable & Equatable {
    #expect(lhs ^ rhs == expectation, "BitOperable.^(_:_:)", sourceLocation: location)
    #expect({ var x = lhs; x ^= rhs; return x }() == expectation, "BitOperable.^=(_:_:)", sourceLocation: location)
}
