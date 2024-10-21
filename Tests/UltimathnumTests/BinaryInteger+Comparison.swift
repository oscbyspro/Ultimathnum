//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Binary Integer x Comparison
//*============================================================================*

@Suite struct BinaryIntegerTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// Here we check that the following invariants hold for all values:
    ///
    ///     integer.hashValue == IXL(load: integer).hashValue
    ///     integer.hashValue == UXL(load: integer).hashValue
    ///
    @Test(
        "BinaryInteger/comparison: hash value is type agnostic",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func hashValueIsTypeAgnostic(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) throws {
        try  whereIs(type)
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try withOnlyOneCallToRequire(type) { require in
                for _ in 0 ..< conditional(debug: 64, release: 256) {
                    let integer = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let integerHashValue = integer.hashValue
                    require(integerHashValue == IXL(load: integer).hashValue)
                    require(integerHashValue == UXL(load: integer).hashValue)
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/comparison: x vs 0",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonVersusGenericZero(randomness: consuming FuzzerInt) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryInteger {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            try withOnlyOneCallToRequire((lhs, rhs)) { require in
                for _ in 0 ..< conditional(debug: 16,  release: 256) {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = U.zero
                    
                    let signum: Signum = lhs.signum()
                    
                    require((lhs).compared(to: rhs) == signum)
                    require((lhs <  rhs) == signum.isNegative)
                    require((lhs >= rhs) != signum.isNegative)
                    require((lhs == rhs) == signum.isZero)
                    require((lhs != rhs) != signum.isZero)
                    require((lhs >  rhs) == signum.isPositive)
                    require((lhs <= rhs) != signum.isPositive)
                    
                    require((lhs).isNegative == signum.isNegative)
                    require((lhs).isZero     == signum.isZero)
                    require((lhs).isPositive == signum.isPositive)
                }
            }
        }
    }
    
    @Test(
        "BinaryInteger/comparison: x vs x.elements",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonIsLikeDataIntegerComparison(randomness: consuming FuzzerInt) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryInteger {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ lhs: T.Type, _ rhs: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            try withOnlyOneCallToRequire((lhs, rhs)) { require in
                for _ in 0 ..< conditional(debug: 16,  release: 256) {
                    let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                    let rhs = U.entropic(through: Shift.max(or: 255), using: &randomness)
                    
                    let comparison = lhs.compared(to: rhs)
                    let dataIntegerComparison = lhs.withUnsafeBinaryIntegerElements { lhs in
                        rhs.withUnsafeBinaryIntegerElements { rhs in
                            DataInt.compare(lhs: lhs, mode: T.mode, rhs: rhs, mode: U.mode)
                        }
                    }
                    
                    require(comparison == dataIntegerComparison)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Comparison x Edge Cases
//*============================================================================*

@Suite(.tags(.documentation, .important), .serialized)
struct BinaryIntegerTestsOnComparisonEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/comparison/edge-cases: ℕ vs ℕ",
        Tag.List.tags(.generic),
        arguments: [
            
            (lhs: 0 as I8, rhs: 0 as I8, expectation: Signum.zero),
            (lhs: 0 as I8, rhs: 1 as I8, expectation: Signum.negative),
            (lhs: 0 as I8, rhs: 2 as I8, expectation: Signum.negative),
            (lhs: 0 as I8, rhs: 3 as I8, expectation: Signum.negative),
            
            (lhs: 1 as I8, rhs: 0 as I8, expectation: Signum.positive),
            (lhs: 1 as I8, rhs: 1 as I8, expectation: Signum.zero),
            (lhs: 1 as I8, rhs: 2 as I8, expectation: Signum.negative),
            (lhs: 1 as I8, rhs: 3 as I8, expectation: Signum.negative),
            
            (lhs: 2 as I8, rhs: 0 as I8, expectation: Signum.positive),
            (lhs: 2 as I8, rhs: 1 as I8, expectation: Signum.positive),
            (lhs: 2 as I8, rhs: 2 as I8, expectation: Signum.zero),
            (lhs: 2 as I8, rhs: 3 as I8, expectation: Signum.negative),
            
            (lhs: 3 as I8, rhs: 0 as I8, expectation: Signum.positive),
            (lhs: 3 as I8, rhs: 1 as I8, expectation: Signum.positive),
            (lhs: 3 as I8, rhs: 2 as I8, expectation: Signum.positive),
            (lhs: 3 as I8, rhs: 3 as I8, expectation: Signum.zero),
            
    ] as [(lhs: I8, rhs: I8, expectation: Signum)])
    func comparisonOfNaturalVersusNatural(lhs: I8, rhs: I8, expectation: Signum) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryInteger {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: BinaryInteger, U: BinaryInteger {
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
            
            self.expect(lhs, equals: rhs, is: expectation)
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: ℕ vs -",
        Tag.List.tags(.generic),
        arguments: I8(0)..<I8(4), I8(-4)..<I8(0)
    )   func comparisonOfNaturalVersusNegative(lhs: I8, rhs: I8) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryIntegerAsSigned {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: BinaryInteger, U: SignedInteger {
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
            
            self.expect(lhs, equals: rhs, is: Signum.positive)
            self.expect(rhs, equals: lhs, is: Signum.negative)
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: ℕ vs ∞",
        Tag.List.tags(.generic),
        arguments: I8(0)..<I8(4), I8(-4)..<I8(0)
    )   func comparisonOfNaturalVersusInfinite(lhs: I8, rhs: I8) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsArbitraryIntegerAsUnsigned {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: BinaryInteger, U: UnsignedInteger {
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
            
            self.expect(lhs, equals: rhs, is: Signum.negative)
            self.expect(rhs, equals: lhs, is: Signum.positive)
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: - vs -",
        Tag.List.tags(.generic),
        arguments: I8(-4)..<I8(0), I8(-4)..<I8(0)
    )   func comparisonOfNegativeVersusNegative(lhs: I8, rhs: I8) throws {
        for lhs in typesAsBinaryIntegerAsSigned {
            for rhs in typesAsBinaryIntegerAsSigned {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: SignedInteger, U: SignedInteger {
            let expectation = lhs.compared(to: rhs)
            
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
                        
            self.expect(lhs, equals: rhs, is: expectation)
            self.expect(rhs, equals: lhs, is: expectation.negated())
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: - vs ∞",
        Tag.List.tags(.generic),
        arguments: I8(-4)..<I8(0), I8(-4)..<I8(0)
    )   func comparisonOfNegativeVersusInfinite(lhs: I8, rhs: I8) throws {
        for lhs in typesAsBinaryIntegerAsSigned {
            for rhs in typesAsArbitraryIntegerAsUnsigned {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: SignedInteger, U: UnsignedInteger {
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
            
            self.expect(lhs, equals: rhs, is: Signum.negative)
            self.expect(rhs, equals: lhs, is: Signum.positive)
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: ∞ vs ∞",
        Tag.List.tags(.generic),
        arguments: I8(-4)..<I8(0), I8(-4)..<I8(0)
    )   func comparisonOfInfiniteVersusInfinite(lhs: I8, rhs: I8) throws {
        for lhs in typesAsArbitraryIntegerAsUnsigned {
            for rhs in typesAsArbitraryIntegerAsUnsigned {
                whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: UnsignedInteger, U: UnsignedInteger {
            let expectation = lhs.compared(to: rhs)
            
            let lhs = T(load: lhs)
            let rhs = U(load: rhs)
            
            self.expect(lhs, equals: rhs, is: expectation)
            self.expect(rhs, equals: lhs, is: expectation.negated())
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Body|Appendix
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/comparison/edge-cases: x vs x with one bit changed",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonOfRandomVersusSelfWithOneBitChanged(randomness: consuming FuzzerInt) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryInteger where lhs.mode == rhs.mode && lhs.size <= rhs.size {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            for _ in 0 ..< conditional(debug: 16,  release: 64) {
                let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                var expectation = Signum.zero
                
                var tmp = lhs; tmp.withUnsafeMutableBinaryIntegerBody(as: U8.self) {
                    var end: IX = $0.size().natural().unwrap()
                    end  -=  IX(Bit(T.isSigned && !T.isArbitrary))
                    if  let index = IX.random(in: IX.zero..<end) {
                        let major = Natural(index).quotient(Nonzero(size: U8.self))
                        let minor = Shift<U8>(masking:index)
                        $0[unchecked: major][minor].toggle()
                        expectation = Signum(Sign(raw: $0[unchecked: major][minor]))
                    }
                }
                
                let rhs = try #require(U.exactly(tmp).optional())
                self.expect(lhs, equals: rhs, is: expectation)
                self.expect(rhs, equals: lhs, is: expectation.negated())
            }
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: x vs y, different appendix",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonOfRandomVersusRandomWithDifferentAppendix(randomness: consuming FuzzerInt) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryIntegerAsAppendix {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            for _ in 0 ..< conditional(debug: 16,  release: 64) {
                let lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                var rhs = U.entropic(through: Shift.max(or: 255), using: &randomness)
                
                if  rhs.appendix == lhs.appendix {
                    rhs.toggle()
                }
                
                let expectation: Signum = switch (T.mode, U.mode) {
                case (Signedness  .signed, Signedness  .signed): Signum(Sign(raw: lhs.appendix))
                case (Signedness  .signed, Signedness.unsigned): Signum.negative
                case (Signedness.unsigned, Signedness  .signed): Signum.positive
                case (Signedness.unsigned, Signedness.unsigned): Signum(Sign(raw: rhs.appendix))
                }
                
                self.expect(lhs, equals: rhs, is: expectation)
                self.expect(rhs, equals: lhs, is: expectation.negated())
            }
        }
    }
    
    @Test(
        "BinaryInteger/comparison/edge-cases: x vs y, same signedness, same appendix, different normal byte count",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func comparisonOfRandomVersusRandomWithSameSignednessSameAppendixButDifferentNormalByteCount(randomness: consuming FuzzerInt) throws {
        for lhs in typesAsBinaryInteger {
            for rhs in typesAsBinaryInteger where lhs.mode == rhs.mode {
                try whereIs(lhs, rhs)
            }
        }
        
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) throws where T: BinaryInteger, U: BinaryInteger {
            for _ in 0 ..< conditional(debug: 16,  release: 64) {
                var lhs = T.entropic(through: Shift.max(or: 255), using: &randomness)
                var rhs = U.entropic(through: Shift.max(or: 255), using: &randomness)
                
                if  lhs.appendix != rhs.appendix {
                    lhs.toggle()
                }
                
                if  lhs.appendix != rhs.appendix {
                    rhs.toggle()
                }
                
                let lhsNormalByteCount = lhs.withUnsafeBinaryIntegerElements(as: U8.self) {
                    $0.normalized().body.count
                }
                
                let rhsNormalByteCount = rhs.withUnsafeBinaryIntegerElements(as: U8.self) {
                    $0.normalized().body.count
                }
                
                try #require(lhs.appendix == rhs.appendix)
                
                let expectation: Signum = switch
                lhsNormalByteCount.compared(to: rhsNormalByteCount) {
                case Signum.negative: -Signum(Sign(raw: lhs.appendix))
                case Signum.zero:      lhs.compared(to: rhs)
                case Signum.positive:  Signum(Sign(raw: lhs.appendix))
                }
                
                self.expect(lhs, equals: rhs, is: expectation)
                self.expect(rhs, equals: lhs, is: expectation.negated())
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func expect<T, U>(
        _      lhs: T,
        equals rhs: U,
        is     expectation: Signum,
        at     location: SourceLocation = #_sourceLocation
    )   where  T: BinaryInteger, U: BinaryInteger {
        
        withOnlyOneCallToExpect((lhs, rhs, expectation), at: location) { expect in
            expect((lhs).compared(to: rhs) == expectation)
            expect((lhs <  rhs) == expectation.isNegative)
            expect((lhs >= rhs) != expectation.isNegative)
            expect((lhs == rhs) == expectation.isZero)
            expect((lhs != rhs) != expectation.isZero)
            expect((lhs >  rhs) == expectation.isPositive)
            expect((lhs <= rhs) != expectation.isPositive)
            
            if  expectation.isZero {
                expect(lhs.hashValue == rhs.hashValue)
            }
            
            if  let rhs = T.exactly(rhs).optional() {
                expect((lhs).compared(to: rhs) == expectation)
                expect((lhs <  rhs) == expectation.isNegative)
                expect((lhs >= rhs) != expectation.isNegative)
                expect((lhs == rhs) == expectation.isZero)
                expect((lhs != rhs) != expectation.isZero)
                expect((lhs >  rhs) == expectation.isPositive)
                expect((lhs <= rhs) != expectation.isPositive)
            }
            
            if  let lhs = U.exactly(lhs).optional() {
                expect((lhs).compared(to: rhs) == expectation)
                expect((lhs <  rhs) == expectation.isNegative)
                expect((lhs >= rhs) != expectation.isNegative)
                expect((lhs == rhs) == expectation.isZero)
                expect((lhs != rhs) != expectation.isZero)
                expect((lhs >  rhs) == expectation.isPositive)
                expect((lhs <= rhs) != expectation.isPositive)
            }
        }
    }
}
