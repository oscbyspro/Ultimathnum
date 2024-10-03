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
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Complement
//*============================================================================*

@Suite struct BinaryIntegerTestsOnComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check that the following invariants hold for all values:
    ///
    /// ```swift
    /// x.complement(false) == x.toggled()
    /// x.complement(true ) == x.toggled().incremented()
    /// x.complement(     ) == x.toggled().incremented().value
    /// ```
    ///
    @Test("BinaryInteger/complement(_:) - [entropic]", arguments: binaryIntegers, fuzzers)
    func complement(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 256, release: 1024) {
                let instance = T.entropic(through: Shift.max(or: 255), mode: .signed, using: &randomness)
                let ones = instance.toggled()
                let twos = ones.incremented()
                Ɣexpect(instance, complement: false, is: ones)
                Ɣexpect(instance, complement: true,  is: twos)
            }
        }
    }
    
    /// Here we check that the following invariants hold for all values:
    ///
    /// ```swift
    /// x.magnitude() == T.Magnitude(raw: x.isNegative ? x.complement() : x)
    /// ```
    ///
    @Test("BinaryInteger/magnitude(_:) - [entropic]", arguments: binaryIntegers, fuzzers)
    func magnitude(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            for _ in 0 ..< conditional(debug: 256, release: 1024) {
                let instance = T.entropic(through: Shift.max(or: 255), mode: .signed, using: &randomness)
                let result = instance.magnitude()
                let expectation = T.Magnitude(raw: instance.isNegative ? instance.complement() : instance)
                #expect(result == expectation)
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Complement x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation)) struct BinaryIntegerTestsOnComplementEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check that the following invariants hold for all edgy intgers:
    ///
    ///     T.min.complement(false) == T.max
    ///     T.min.complement(true ) == T.min.veto() // (!)
    ///     T.max.complement(false) == T.min
    ///     T.max.complement(true ) == T.min.incremented()
    ///
    /// - Note: `T.min.complement(true)` is the only `error` case.
    ///
    @Test("BinaryInteger/complement(_:) of edges", arguments: edgyIntegers)
    func complementOfEdges(type: any EdgyInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: EdgyInteger {
            Ɣexpect(T.min, complement: false, is: T.max)
            Ɣexpect(T.min, complement: true,  is: T.min.veto())
            Ɣexpect(T.max, complement: false, is: T.min)
            Ɣexpect(T.max, complement: true,  is: T.min.incremented())
        }
    }
    
    /// Here we check that the following invariants hold for all values:
    ///
    /// ```swift
    /// T(load: [      ] as [T.Element.Magnitude], repeating: Bit.zero) //  a
    /// T(load: [      ] as [T.Element.Magnitude], repeating: Bit.one ) // ~a
    /// T(load: [      ] as [T.Element.Magnitude], repeating: Bit.zero) // ~a &+ 1 == b
    /// T(load: [      ] as [T.Element.Magnitude], repeating: Bit.one ) // ~b
    /// T(load: [      ] as [T.Element.Magnitude], repeating: Bit.zero) // ~b &+ 1 == b
    ///
    /// T(load: [~0    ] as [T.Element.Magnitude], repeating: Bit.zero) //  a
    /// T(load: [ 0    ] as [T.Element.Magnitude], repeating: Bit.one ) // ~a
    /// T(load: [ 1    ] as [T.Element.Magnitude], repeating: Bit.one ) // ~a &+ 1 == b
    /// T(load: [~1    ] as [T.Element.Magnitude], repeating: Bit.zero) // ~b
    /// T(load: [~0    ] as [T.Element.Magnitude], repeating: Bit.zero) // ~b &+ 1 == a
    ///
    /// T(load: [ 0    ] as [T.Element.Magnitude], repeating: Bit.one ) //  a
    /// T(load: [~0    ] as [T.Element.Magnitude], repeating: Bit.zero) // ~a
    /// T(load: [ 0,  1] as [T.Element.Magnitude], repeating: Bit.zero) // ~a &+ 1 == b
    /// T(load: [~0, ~1] as [T.Element.Magnitude], repeating: Bit.one ) // ~b
    /// T(load: [ 0    ] as [T.Element.Magnitude], repeating: Bit.one ) // ~b &+ 1 == a
    /// ```
    ///
    @Test("BinaryInteger/complement(_:) is well-behaved", arguments: binaryIntegers)
    func complementIsWellBehaved(type: any BinaryInteger.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias  Body = [T.Element.Magnitude]
            let usmol: Bool = !T.isSigned && T.size == T.Element.size
            
            Ɣexpect(T(load: [      ] as Body, repeating: Bit.zero), complement: false, is: T(load: [      ] as Body, repeating: Bit.one ))
            Ɣexpect(T(load: [      ] as Body, repeating: Bit.zero), complement: true,  is: T(load: [      ] as Body, repeating: Bit.zero), error: !T.isSigned)
            
            Ɣexpect(T(load: [~0    ] as Body, repeating: Bit.zero), complement: false, is: T(load: [ 0    ] as Body, repeating: Bit.one ))
            Ɣexpect(T(load: [~0    ] as Body, repeating: Bit.zero), complement: true,  is: T(load: [ 1    ] as Body, repeating: Bit.one ))
            Ɣexpect(T(load: [ 1    ] as Body, repeating: Bit.one ), complement: false, is: T(load: [~1    ] as Body, repeating: Bit.zero))
            Ɣexpect(T(load: [ 1    ] as Body, repeating: Bit.one ), complement: true,  is: T(load: [~0    ] as Body, repeating: Bit.zero))
            
            Ɣexpect(T(load: [ 0    ] as Body, repeating: Bit.one ), complement: false, is: T(load: [~0    ] as Body, repeating: Bit.zero))
            Ɣexpect(T(load: [ 0    ] as Body, repeating: Bit.one ), complement: true,  is: T(load: [ 0,  1] as Body, repeating: Bit.zero), error: usmol)
            Ɣexpect(T(load: [ 0,  1] as Body, repeating: Bit.zero), complement: false, is: T(load: [~0, ~1] as Body, repeating: Bit.one ))
            Ɣexpect(T(load: [ 0,  1] as Body, repeating: Bit.zero), complement: true,  is: T(load: [ 0    ] as Body, repeating: Bit.one ), error: usmol)
        }
    }
}
