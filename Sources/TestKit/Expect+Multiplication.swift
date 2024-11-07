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
// MARK: * Expect x Multiplication x Binary Integer
//*============================================================================*

@inlinable public func Ɣexpect<T>(
    _ lhs: T,
    times rhs: T,
    is  low: Fallible<T>,
    and high: T? = nil,
    derivatives: Bool = true,
    division: Bool = true,
    at  location: SourceLocation = #_sourceLocation
)   where T: BinaryInteger {
    //=------------------------------------------=
    let inputsAreEqual = lhs == rhs
    let high = high ?? T(repeating: low.value.appendix)
    let wide = Doublet(low: T.Magnitude(raw: low.value), high: high)
    //=------------------------------------------=
    if  derivatives {
        derivativesOneWayOnly(lhs, rhs)
    }
    
    if  derivatives, !inputsAreEqual {
        derivativesOneWayOnly(rhs, lhs)
    }
    
    always: do {
        #expect(lhs.times(rhs) == low, "BinaryInteger/times(_:)", sourceLocation: location)
    }
    
    if !inputsAreEqual {
        #expect(rhs.times(lhs) == low, "BinaryInteger/times(_:)", sourceLocation: location)
    }
    
    if  inputsAreEqual {
        #expect(lhs.squared()  == low, "BinaryInteger/squared()", sourceLocation: location)
    }
    
    always: do {
        #expect(lhs.multiplication(rhs) == wide, "BinaryInteger/multiplication(_:)", sourceLocation: location)
    }
    
    if !inputsAreEqual {
        #expect(rhs.multiplication(lhs) == wide, "BinaryInteger/multiplication(_:)", sourceLocation: location)
    }
    
    if  division, !low.error {
        divisionOneWayOnly(lhs, rhs)
    }
    
    if  division, !low.error, !inputsAreEqual {
        divisionOneWayOnly(rhs, lhs)
    }
    
    complements: do {
        let lhsComplement = lhs.complement()
        let rhsComplement = rhs.complement()
        let lowComplement = low.value.complement()
        
        always: do {
            #expect(lhs.times(rhsComplement).value == (((lowComplement))), "BinaryInteger/times(_:) - complement [0]", sourceLocation: location)
            #expect(lhsComplement.times(rhs).value == (((lowComplement))), "BinaryInteger/times(_:) - complement [1]", sourceLocation: location)
            #expect(lhsComplement.times(rhsComplement).value == low.value, "BinaryInteger/times(_:) - complement [2]", sourceLocation: location)
        }

        if !inputsAreEqual {
            #expect(rhs.times(lhsComplement).value == (((lowComplement))), "BinaryInteger/times(_:) - complement [3]", sourceLocation: location)
            #expect(rhsComplement.times(lhs).value == (((lowComplement))), "BinaryInteger/times(_:) - complement [4]", sourceLocation: location)
        }
        
        if  inputsAreEqual {
            #expect(lhsComplement.squared( ).value == (((((low.value))))), "BinaryInteger/squared() - complement [5]", sourceLocation: location)
        }
    }
    
    drain: do {
        guard let a = lhs.ascending(Bit.zero).natural().optional() else { break drain }
        guard let b = rhs.ascending(Bit.zero).natural().optional() else { break drain }
        guard let c = a.plus(b).optional() else { break drain }
        
        let lhsDown = (lhs >>  a)
        let rhsDown = (rhs >>  b)
        
        always: do {
            #expect(((lhs)).times(rhsDown).value << b == low.value, "BinaryInteger/times(_:) - drain [0]", sourceLocation: location)
            #expect(lhsDown.times(rhsDown).value << c == low.value, "BinaryInteger/times(_:) - drain [1]", sourceLocation: location)
        }
        
        if !inputsAreEqual {
            #expect(lhsDown.times(((rhs))).value << a == low.value, "BinaryInteger/times(_:) - drain [2]", sourceLocation: location)
        }
        
        if  inputsAreEqual {
            #expect(lhsDown.squared(     ).value << c == low.value, "BinaryInteger/times(_:) - drain [3]", sourceLocation: location)
        }
    }
    //=------------------------------------------=
    func divisionOneWayOnly(_ lhs: T, _ rhs: T) {
        if  let dividend = Finite(exactly: low.value), let divisor = Nonzero(exactly: rhs) {
            let division = dividend.division(divisor)
            #expect(division.value.quotient  == lhs, "invariant: (a * b) / b == a", sourceLocation: location)
            #expect(division.value.remainder.isZero, "invariant: (a * b) % b == 0", sourceLocation: location)
        }
    }
    
    func derivativesOneWayOnly(_ lhs: T, _ rhs: T) {
        scope: do {
            #expect(lhs &* rhs == low.value, "BinaryInteger.&*(_:_:)", sourceLocation: location)
        }
        
        scope: if !low.error {
            #expect(lhs  * rhs == low.value, "BinaryInteger.*(_:_:)",  sourceLocation: location)
        }
        
        scope: do {
            #expect({ var x = lhs; x &*= rhs; return x }() == low.value, "BinaryInteger.&*=(_:_:)", sourceLocation: location)
        }
        
        scope: if !low.error {
            #expect({ var x = lhs; x  *= rhs; return x }() == low.value, "BinaryInteger.*=(_:_:)",  sourceLocation: location)
        }
    }
}

//*============================================================================*
// MARK: * Expect x Multiplication x Data Integer
//*============================================================================*

@inlinable public func Ɣexpect<Element>(
    _ integer: [Element],
    times multiplier: [Element],
    plus increment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(expectation.count == integer.count  + multiplier.count)
    try #require(expectation.count >= 0000000000001 || increment.isZero)
    //=------------------------------------------=
    // multiplication: expectation <= U64.max
    //=------------------------------------------=
    if  IX(expectation.count) * IX(size: Element.self) <= 64 {
        let a = try #require(U64.exactly(integer    ).optional())
        let b = try #require(U64.exactly(multiplier ).optional())
        let c = try #require(U64.exactly(increment  ).optional())
        let d = try #require(U64.exactly(expectation).optional())
        let e = a.times(b).optional()?.plus(c).optional()
        #expect(e == d, "DataInt/initialize(to:times:plus:) <= U64.max", sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × some + some
    //=------------------------------------------=
    if  integer.count == 1 {
        var result = multiplier
        let last = result.withUnsafeMutableBinaryIntegerBody {
            $0.multiply(by: integer.first!, add: increment)
        }
        
        result.append(last)
        #expect(result == expectation, sourceLocation: location)
    }
    
    if  multiplier.count == 1 {
        var result = integer
        let last = result.withUnsafeMutableBinaryIntegerBody {
            $0.multiply(by: multiplier.first!, add: increment)
        }
        
        result.append(last)
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × many
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByLongAlgorithm(to: integer, times: multiplier)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
        }

        #expect(result == expectation, sourceLocation: location)
    }

    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                try multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByKaratsubaAlgorithm(to: integer, times: multiplier)
                    if !result.isEmpty {
                        try #require(!result.increment(by: increment).error)
                    }
                }
            }
        }

        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: many × many + some
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        result.withUnsafeMutableBinaryIntegerBody { result in
            integer.withUnsafeBinaryIntegerBody { integer in
                multiplier.withUnsafeBinaryIntegerBody { multiplier in
                    result.initializeByLongAlgorithm(to: integer, times: multiplier, plus: increment)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}

@inlinable public func Ɣexpect<Element>(
    squared integer: [Element],
    plus increment: Element,
    is expectation: [Element],
    at location: SourceLocation = #_sourceLocation
)   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
    //=------------------------------------------=
    try #require(expectation.count == integer.count  + integer   .count)
    try #require(expectation.count >= 0000000000001 || increment.isZero)
    //=------------------------------------------=
    // multiplication: long
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByLongAlgorithm(toSquareProductOf: integer)
                if !result.isEmpty {
                    try #require(!result.increment(by: increment).error)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        result.withUnsafeMutableBinaryIntegerBody { result in
            integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByLongAlgorithm(toSquareProductOf: integer, plus: increment)
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
    //=------------------------------------------=
    // multiplication: karatsuba
    //=------------------------------------------=
    always: do {
        var result = [Element](repeating: 144, count: expectation.count)
        try result.withUnsafeMutableBinaryIntegerBody { result in
            try integer.withUnsafeBinaryIntegerBody { integer in
                result.initializeByKaratsubaAlgorithm(toSquareProductOf: integer)
                if !result.isEmpty {
                    try #require(!result.increment(by: increment).error)
                }
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}
