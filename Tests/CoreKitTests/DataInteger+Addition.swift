//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntIop
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Data Integer x Addition
//*============================================================================*

@Suite struct DataIntegerTestsOnAddition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many ± (Many + Bit)
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/addition: none + (none + bit)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsUnsigned
    )   func incrementNoneByNonePlusBit(
        type: any CoreIntegerAsUnsigned.Type
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            try Ɣrequire([] as [T], increment: [] as [T], plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], increment: [] as [T], plus: true,  is: Fallible([] as [T], error: true ))
        }
    }
    
    @Test(
        "DataInt/addition: none - (none + bit)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsUnsigned
    )   func decrementNoneByNonePlusBit(
        type: any CoreIntegerAsUnsigned.Type
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            try Ɣrequire([] as [T], decrement: [] as [T], plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], decrement: [] as [T], plus: true,  is: Fallible([] as [T], error: true))
        }
    }
    
    @Test(
        "DataInt/addition: many + (many + bit)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func incrementManyByManyPlusBit(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T] .random (count: 1...32,        using: &randomness)
                let rhs = [T] .random (count: 0...lhs.count, using: &randomness)
                let bit = Bool.random (using: &randomness.stdlib)
                
                var res = lhs
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    rhs.withUnsafeBinaryIntegerBody { rhs in
                        res.increment(by: rhs, plus: bit).error
                    }
                }
                
                try Ɣrequire(lhs, increment: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣrequire(res, decrement: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test(
        "DataInt/addition: many - (many + bit)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func decrementManyByManyPlusBit(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T] .random (count: 1...32,        using: &randomness)
                let rhs = [T] .random (count: 0...lhs.count, using: &randomness)
                let bit = Bool.random (using: &randomness.stdlib)
                
                var res = lhs
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    rhs.withUnsafeBinaryIntegerBody { rhs in
                        res.decrement(by: rhs, plus: bit).error
                    }
                }
                
                try Ɣrequire(lhs, decrement: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣrequire(res, increment: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many ± (Many × Some + Bit)
    //=------------------------------------------------------------------------=
    // NOTE: The left-hand-side must contain at least 1 element in this section.
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/addition: many + (many × some + some)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func incrementManyByManyTimesSomePlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T].random  (count: 1...32,        using: &randomness)
                let rhs = [T].random  (count: 0..<lhs.count, using: &randomness)
                let mul = (T).entropic(using: &randomness)
                let add = (T).entropic(using: &randomness)
                
                var res = lhs
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    rhs.withUnsafeBinaryIntegerBody { rhs in
                        let a = mul.floorceil()!
                        let b = add.floorceil()!
                        let x = res.increment(by: rhs, times: a.floor, plus: b.floor).error
                        let y = res.increment(by: rhs, times: a.ceil,  plus: b.ceil ).error
                        return (x || y)
                    }
                }
                
                try Ɣrequire(lhs, increment: rhs, times: mul, plus: add, is: Fallible(res, error: err))
                try Ɣrequire(res, decrement: rhs, times: mul, plus: add, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test(
        "DataInt/addition: many - (many × some + some)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func decrementManyByManyTimesSomePlusSome(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T].random  (count: 1...32,        using: &randomness)
                let rhs = [T].random  (count: 0..<lhs.count, using: &randomness)
                let mul = (T).entropic(using: &randomness)
                let add = (T).entropic(using: &randomness)
                
                var res = lhs
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    rhs.withUnsafeBinaryIntegerBody { rhs in
                        let a = mul.floorceil()!
                        let b = add.floorceil()!
                        let x = res.decrement(by: rhs, times: a.floor, plus: b.floor).error
                        let y = res.decrement(by: rhs, times: a.ceil,  plus: b.ceil ).error
                        return (x || y)
                    }
                }
                
                try Ɣrequire(lhs, decrement: rhs, times: mul, plus: add, is: Fallible(res, error: err))
                try Ɣrequire(res, increment: rhs, times: mul, plus: add, is: Fallible(lhs, error: err))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many ± (Reps + Bit)
    //=------------------------------------------------------------------------=
    
    @Test(
        "DataInt/addition: none + (reps + bit)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsUnsigned
    )   func incrementNoneByRepsPlusBit(
        type: any CoreIntegerAsUnsigned.Type
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            try Ɣrequire([] as [T], incrementSameSizeRepeating: false, plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], incrementSameSizeRepeating: false, plus: true,  is: Fallible([] as [T], error: true ))
            try Ɣrequire([] as [T], incrementSameSizeRepeating: true,  plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], incrementSameSizeRepeating: true,  plus: true,  is: Fallible([] as [T], error: true ))
        }
    }
    
    @Test(
        "DataInt/addition: none - (reps + bit)",
        Tag.List.tags(.exhaustive, .generic),
        arguments: typesAsCoreIntegerAsUnsigned
    )   func decrementNoneByRepsPlusBit(
        type: any CoreIntegerAsUnsigned.Type
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            try Ɣrequire([] as [T], decrementSameSizeRepeating: false, plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], decrementSameSizeRepeating: false, plus: true,  is: Fallible([] as [T], error: true ))
            try Ɣrequire([] as [T], decrementSameSizeRepeating: true,  plus: false, is: Fallible([] as [T], error: false))
            try Ɣrequire([] as [T], decrementSameSizeRepeating: true,  plus: true,  is: Fallible([] as [T], error: true ))
        }
    }
    
    @Test(
        "DataInt/addition: many + (reps + bit)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func incrementManyByRepsPlusBit(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T] .random (count: 1...32, using: &randomness)
                let rhs = Bool.random (using: &randomness.stdlib)
                let bit = Bool.random (using: &randomness.stdlib)
                                
                var res = lhs
                let exp = Array(repeating: T(repeating: Bit(rhs)), count: lhs.count)
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    exp.withUnsafeBinaryIntegerBody { rhs in
                        res.increment(by: rhs, plus: bit).error
                    }
                }
                
                try Ɣrequire(lhs, incrementSameSizeRepeating: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣrequire(res, decrementSameSizeRepeating: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    @Test(
        "DataInt/addition: many - (reps + bit)",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsUnsigned, fuzzers
    )   func decrementManyByRepsPlusBit(
        type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: CoreIntegerAsUnsigned {
            for _ in 0 ..< conditional(debug: 64, release: 1024) {
                let lhs = [T] .random (count: 1...32, using: &randomness)
                let rhs = Bool.random (using: &randomness.stdlib)
                let bit = Bool.random (using: &randomness.stdlib)
                
                var res = lhs
                let exp = Array(repeating: T(repeating: Bit(rhs)), count: lhs.count)
                let err = res.withUnsafeMutableBinaryIntegerBody { res in
                    exp.withUnsafeBinaryIntegerBody { rhs in
                        res.decrement(by: rhs, plus: bit).error
                    }
                }
                
                try Ɣrequire(lhs, decrementSameSizeRepeating: rhs, plus: bit, is: Fallible(res, error: err))
                try Ɣrequire(res, incrementSameSizeRepeating: rhs, plus: bit, is: Fallible(lhs, error: err))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Many ± (Many + Bit)
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<Element>(
        _ integer: [Element],
        increment other: [Element],
        plus bit: Bool,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count >= other.count)
        //=--------------------------------------=
        let normalized = other.asBinaryIntegerBodyNormalized()
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
        if  normalized.count == 0, bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.increment().error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        
        if  normalized.count == 0 {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.increment(by: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: some
        //=--------------------------------------=
        if  integer.count >= 1, normalized.count == 1, !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.increment(by: normalized.first!).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: some + bit
        //=--------------------------------------=
        if  integer.count >= 1, normalized.count == 1 {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.increment(by: normalized.first!, plus: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: many
        //=--------------------------------------=
        for many in [normalized, other[...]] where integer.count >= many.count && !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.increment(by: many).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        for many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.increment(by: many, plus: bit).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: flip + bit
        //=--------------------------------------=
        for var many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeMutableBinaryIntegerBody { many in
                    many.toggle(carrying: false).discard()
                    return value.increment(toggling: DataInt.Body(many), plus: bit).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        
        for var many in [normalized, other[...]] where !bit && !normalized.isEmpty {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeMutableBinaryIntegerBody { many in
                    many.toggle(carrying: true).discard()
                    return value.increment(toggling: DataInt.Body(many), plus: true).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
    }

    private func Ɣrequire<Element>(
        _ integer: [Element],
        decrement other: [Element],
        plus bit: Bool,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count >= other.count)
        //=--------------------------------------=
        let normalized = other.asBinaryIntegerBodyNormalized()
        //=--------------------------------------=
        // decrement: none + bit
        //=--------------------------------------=
        if  normalized.count == 0, bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrement().error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        
        if  normalized.count == 0 {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrement(by: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: some
        //=--------------------------------------=
        if  integer.count >= 1, normalized.count == 1, !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrement(by: normalized.first!).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: some + bit
        //=--------------------------------------=
        if  integer.count >= 1, normalized.count == 1 {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrement(by: normalized.first!, plus: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: many
        //=--------------------------------------=
        for many in [normalized, other[...]] where !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.decrement(by: many).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: many + bit
        //=--------------------------------------=
        for many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.decrement(by: many, plus: bit).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: toggling + bit
        //=--------------------------------------=
        for var many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeMutableBinaryIntegerBody { many in
                    many.toggle(carrying: false).discard()
                    return value.decrement(toggling: DataInt.Body(many), plus: bit).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        
        for var many in [normalized, other[...]] where !bit && !normalized.isEmpty {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeMutableBinaryIntegerBody { many in
                    many.toggle(carrying: true).discard()
                    return value.decrement(toggling: DataInt.Body(many), plus: true).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities x Many ± (Many × Some + Bit)
    //=------------------------------------------------------------------------=

    private func Ɣrequire<Element>(
        _ integer: [Element],
        increment other: [Element],
        times multiplier: Element,
        plus  increment: Element,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count > other.count)
        //=--------------------------------------=
        let normalized = other.asBinaryIntegerBodyNormalized()
        //=--------------------------------------=
        // increment: many × some
        //=--------------------------------------=
        for many in [normalized, other[...]] where increment.isZero {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.increment(by: many, times: multiplier).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: many × some + some
        //=--------------------------------------=
        for many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.increment(by: many, times: multiplier, plus: increment).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: many × some + some (naive)
        //=--------------------------------------=
        for many in [normalized, other[...]] where multiplier <= 16 {
            var value = integer
            var error = false
            value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    for _ in 0 ..< multiplier {
                        value.increment(by:  many).sink(&error)
                    }
                    
                    value.increment(by: increment).sink(&error)
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
    }

    private func Ɣrequire<Element>(
        _ integer: [Element],
        decrement other: [Element],
        times multiplier: Element,
        plus  increment:  Element,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        try #require(integer.count > other.count)
        //=--------------------------------------=
        let normalized = other.asBinaryIntegerBodyNormalized()
        //=--------------------------------------=
        // decrement: many × some
        //=--------------------------------------=
        for many in [normalized, other[...]] where increment.isZero {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.decrement(by: many, times: multiplier).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: many × some + some
        //=--------------------------------------=
        for many in [normalized, other[...]] {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    value.decrement(by: many, times: multiplier, plus: increment).error
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: many × some + some (naive)
        //=--------------------------------------=
        for many in [normalized, other[...]] where multiplier <= 16 {
            var value = integer
            var error = false
            value.withUnsafeMutableBinaryIntegerBody { value in
                many.withUnsafeBinaryIntegerBody { many in
                    for _ in 0 ..< multiplier {
                        value.decrement(by:  many).sink(&error)
                    }
                    
                    value.decrement(by: increment).sink(&error)
                }
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities x Many ± (Reps + Bit)
    //=------------------------------------------------------------------------=
    
    private func Ɣrequire<Element>(
        _ integer: [Element],
        incrementSameSizeRepeating pattern: Bool,
        plus bit: Bool,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        if  pattern == bit {
            try #require(Fallible(integer, error: bit) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: none + bit
        //=--------------------------------------=
        if !pattern {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.increment(by: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: reps
        //=--------------------------------------=
        if !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.incrementSameSize(repeating: pattern).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: reps + bit
        //=--------------------------------------=
        always: do {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.incrementSameSize(repeating: pattern, plus: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // increment: many + bit
        //=--------------------------------------=
        always: do {
            let element = Element(repeating: Bit(pattern))
            let other = Array(repeating: element, count: integer.count)
            try Ɣrequire(integer, increment: other, plus: bit, is: expectation, at: location)
        }
    }
    
    private func Ɣrequire<Element>(
        _ integer: [Element],
        decrementSameSizeRepeating pattern: Bool,
        plus bit: Bool,
        is expectation: Fallible<[Element]>,
        at location: SourceLocation = #_sourceLocation
    )   throws where Element: SystemsIntegerAsUnsigned, Element.Element == Element {
        //=--------------------------------------=
        if  pattern == bit {
            try #require(Fallible(integer, error: bit) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: none + bit
        //=--------------------------------------=
        if !pattern {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrement(by: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: reps
        //=--------------------------------------=
        if !bit {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrementSameSize(repeating: pattern).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: reps + bit
        //=--------------------------------------=
        always: do {
            var value = integer
            let error = value.withUnsafeMutableBinaryIntegerBody { value in
                value.decrementSameSize(repeating: pattern, plus: bit).error
            }
            
            try #require(Fallible(value, error: error) == expectation, sourceLocation: location)
        }
        //=--------------------------------------=
        // decrement: many + bit
        //=--------------------------------------=
        always: do {
            let element = Element(repeating: Bit(pattern))
            let other = Array(repeating: element, count: integer.count)
            try Ɣrequire(integer, decrement: other, plus: bit, is: expectation, at: location)
        }
    }
}
