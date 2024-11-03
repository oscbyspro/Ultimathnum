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
// MARK: * Expect x Addition x Data Integer
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Many + Bit
//=----------------------------------------------------------------------------=

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    increment other: [Element],
    plus bit: Bool,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(integer.count >= other.count)
    //=------------------------------------------=
    let normalized = other.asBinaryIntegerBodyNormalized()
    //=------------------------------------------=
    // increment: none + bit
    //=------------------------------------------=
    if  normalized.count == 0, bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.increment().error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    
    if  normalized.count == 0 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.increment(by: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: some
    //=------------------------------------------=
    if  integer.count >= 1, normalized.count == 1, !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.increment(by: normalized.first!).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: some + bit
    //=------------------------------------------=
    if  integer.count >= 1, normalized.count == 1 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.increment(by: normalized.first!, plus: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: many
    //=------------------------------------------=
    for many in [normalized, other[...]] where integer.count >= many.count && !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.increment(by: many).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: many + bit
    //=------------------------------------------=
    for many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.increment(by: many, plus: bit).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: flip + bit
    //=------------------------------------------=
    for var many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeMutableBinaryIntegerBody { many in
                many.toggle(carrying: false).discard()
                return value.increment(toggling: DataInt.Body(many), plus: bit).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    
    for var many in [normalized, other[...]] where !bit && !normalized.isEmpty {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeMutableBinaryIntegerBody { many in
                many.toggle(carrying: true).discard()
                return value.increment(toggling: DataInt.Body(many), plus: true).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    decrement other: [Element],
    plus bit: Bool,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(integer.count >= other.count)
    //=------------------------------------------=
    let normalized = other.asBinaryIntegerBodyNormalized()
    //=------------------------------------------=
    // decrement: none + bit
    //=------------------------------------------=
    if  normalized.count == 0, bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrement().error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    
    if  normalized.count == 0 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrement(by: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: some
    //=------------------------------------------=
    if  integer.count >= 1, normalized.count == 1, !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrement(by: normalized.first!).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: some + bit
    //=------------------------------------------=
    if  integer.count >= 1, normalized.count == 1 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrement(by: normalized.first!, plus: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: many
    //=------------------------------------------=
    for many in [normalized, other[...]] where !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.decrement(by: many).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: many + bit
    //=------------------------------------------=
    for many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.decrement(by: many, plus: bit).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: toggling + bit
    //=------------------------------------------=
    for var many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeMutableBinaryIntegerBody { many in
                many.toggle(carrying: false).discard()
                return value.decrement(toggling: DataInt.Body(many), plus: bit).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    
    for var many in [normalized, other[...]] where !bit && !normalized.isEmpty {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeMutableBinaryIntegerBody { many in
                many.toggle(carrying: true).discard()
                return value.decrement(toggling: DataInt.Body(many), plus: true).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many × Some + Bit
//=----------------------------------------------------------------------------=

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    increment other: [Element],
    times multiplier: Element,
    plus  increment: Element,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(integer.count > other.count)
    //=------------------------------------------=
    let normalized = other.asBinaryIntegerBodyNormalized()
    //=------------------------------------------=
    // increment: many × some
    //=------------------------------------------=
    for many in [normalized, other[...]] where increment.isZero {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.increment(by: many, times: multiplier).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: many × some + some
    //=------------------------------------------=
    for many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.increment(by: many, times: multiplier, plus: increment).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: many × some + some (naive)
    //=------------------------------------------=
    for many in [normalized, other[...]] where multiplier <= 16 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                var error: Bool = value.increment(by: increment).error
                
                for _ in 0 ..< multiplier {
                    error = (value.increment(by: many).error || error)
                }
                
                return error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    decrement other: [Element],
    times multiplier: Element,
    plus  increment:  Element,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(integer.count > other.count)
    //=------------------------------------------=
    let normalized = other.asBinaryIntegerBodyNormalized()
    //=------------------------------------------=
    // decrement: many × some
    //=------------------------------------------=
    for many in [normalized, other[...]] where increment.isZero {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.decrement(by: many, times: multiplier).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: many × some + some
    //=------------------------------------------=
    for many in [normalized, other[...]] {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                value.decrement(by: many, times: multiplier, plus: increment).error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: many × some + some (naive)
    //=------------------------------------------=
    for many in [normalized, other[...]] where multiplier <= 16 {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            many.withUnsafeBinaryIntegerBody { many in
                var error: Bool = value.decrement(by: increment).error
                
                for _ in 0 ..< multiplier {
                    error = (value.decrement(by: many).error || error)
                }
                
                return error
            }
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
}

//=------------------------------------------------------------------------=
// MARK: + Reps + Bit
//=------------------------------------------------------------------------=

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    incrementSameSizeRepeating pattern: Bool,
    plus bit: Bool,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    if  pattern == bit {
        #expect(Fallible(integer, error: bit) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: none + bit
    //=------------------------------------------=
    if !pattern {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.increment(by: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: reps
    //=------------------------------------------=
    if !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.incrementSameSize(repeating: pattern).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: reps + bit
    //=------------------------------------------=
    always: do {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.incrementSameSize(repeating: pattern, plus: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // increment: many + bit
    //=------------------------------------------=
    always: do {
        let element = Element(repeating: Bit(pattern))
        let other = Array(repeating: element, count: integer.count)
        try Ɣexpect(integer, increment: other, plus: bit, is: expectation, at: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    decrementSameSizeRepeating pattern: Bool,
    plus bit: Bool,
    is expectation: Fallible<[Element]>,
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    if  pattern == bit {
        #expect(Fallible(integer, error: bit) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: none + bit
    //=------------------------------------------=
    if !pattern {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrement(by: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: reps
    //=------------------------------------------=
    if !bit {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrementSameSize(repeating: pattern).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: reps + bit
    //=------------------------------------------=
    always: do {
        var value = integer
        let error = value.withUnsafeMutableBinaryIntegerBody { value in
            value.decrementSameSize(repeating: pattern, plus: bit).error
        }
        
        #expect(Fallible(value, error: error) == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // decrement: many + bit
    //=------------------------------------------=
    always: do {
        let element = Element(repeating: Bit(pattern))
        let other = Array(repeating: element, count: integer.count)
        try Ɣexpect(integer, decrement: other, plus: bit, is: expectation, at: location)
    }
}
