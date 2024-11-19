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
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Exponentiation
//*============================================================================*

@Suite struct BinaryIntegerTestsOnExponentiation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Seealso: https://www.wolframalpha.com/input?i2d=true&i=Power%5B2%2C1399%5D
    /// - Seealso: https://www.wolframalpha.com/input?i2d=true&i=Power%5B3%2C2239%5D
    @Test(
        "BinaryInteger/exponentiation: examples",
        Tag.List.tags(.generic),
        arguments: Array<(IXL, UXL, IXL)>.infer([
        
        (base: 2 as IXL, exponent: 1399 as UXL, power: IXL("""
        0000000000000000000000000013834514851379060073245971093437442064\
        9160977983437969614705766643223075185306094487364790624541806526\
        1469876608299964693394277268648930360258831509072633846696053692\
        0615225071992089480779025598319909176616250787667116220112182629\
        2066306122745343237483669467464293469194680096834470280624398144\
        7140309400278171194198038370675489371535762220733644100930478390\
        9871197489979144724073675307870340798761005614290980492634226688
        """)!),
        
        (base: 3 as IXL, exponent: 2239 as UXL, power: IXL("""
        0000000000000000000188143542653317364740047262022158266784428791\
        9275755434856235633416147929751345775198585370887106410700145660\
        6941136649945052148587729379215298759841906211465894489332805610\
        3754563980603820020778896725273833377637201111950279005112886290\
        8217517791462710719585984177457155945873475389047023763181890095\
        9473781620831209436384360444149350498181207507201081140457731667\
        8330429216786541702964381293439187677376199748692174845775469107\
        1970497833817135114559784314771606933781164789651479259636951051\
        1939631603190331045111418380453489110302905083967247056298476321\
        3031701771676257422898074561340984020468039563665625492587401150\
        2217805773793168451721091497379753074682133867791141932470210853\
        5500447924439317916852983725285062418604919143133304424502097997\
        8608095945569404820035699584592750436592636252055799816797294408\
        0379347764424614210540528598264992483071934555760511919452459358\
        8835641810301075822245153655314705395817134933252061409024669198\
        8059476349693766699090206318226803178343171280950787682695695659\
        6036250169540192297202679456092601217013126286587177412655204267
        """)!),
            
    ])) func examples(base: IXL, exponent: UXL, power: IXL) throws {
        for type in typesAsBinaryInteger {
            try whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  let base = T.exactly(base).optional() {
                try #require(base.power(exponent) == T.exactly(power))
            }
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation: vs multiplication loop for small exponents",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func exponentiationVersusMultiplicationLoopForSmallExponents(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            let size = IX(size: T.self) ?? conditional(debug: 32, release: 256)
            
            for _  in 0 ..< conditional(debug: 4, release: 16) {
                let base = T.entropic(size: size, using: &randomness)
                let coefficient = T.entropic(size: size, using: &randomness)
                var power = Fallible(coefficient)
                
                for exponent: T.Magnitude in 0 ..< 16 {
                    try #require(base.power(exponent, coefficient: coefficient) == power)
                    power = power.map{$0.times(base)}
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Exponentiation x Conveniences
//*============================================================================*

@Suite struct BinaryIntegerTestsOnExponentiationConveniences {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/exponentiation/conveniences: disambiguation",
        Tag.List.tags(.disambiguation, .generic)
    )   func disambiguation() {
        func build<T>(_ x: inout T) where T: BinaryInteger {
            _ = x.power(0)
            _ = x.power(0 as UX)
            _ = x.power(0,       coefficient: 0)
            _ = x.power(0 as UX, coefficient: 0)
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/conveniences: coefficient is one by default",
        Tag.List.tags(.generic),
        arguments: typesAsBinaryInteger
    )   func coefficientIsOneByDefault(type: any BinaryInteger.Type) throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            try #require(I8(2).power(U8(3)) == Fallible(I8(8)))
            try #require(U8(2).power(U8(3)) == Fallible(U8(8)))
            try #require(I8(2).power(UX(3)) == Fallible(I8(8)))
            try #require(U8(2).power(UX(3)) == Fallible(U8(8)))
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/conveniences: exponent as SystemsInteger.Magnitude vs UXL",
        Tag.List.tags(.generic, .random),
        arguments: typesAsSystemsInteger, fuzzers
    )   func exponentAsSystemsIntegerMagnitudeVersusUXL(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            typealias M = T.Magnitude
            
            for _ in 0 ..< 4 {
                let a = T.entropic(using: &randomness)
                let b = M.entropic(using: &randomness)
                let c = T.entropic(using: &randomness)
                let x = a.power(   (b), coefficient:c)
                let y = a.power(UXL(b), coefficient:c)
                try #require((((((((((x == y))))))))))
            }
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Exponentiation x Edge Cases
//*============================================================================*

@Suite struct BinaryIntegerTestsOnExponentiationEdgeCases {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Base
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/exponentiation/edge-cases: base is 1 → coefficient",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func baseIsOneYieldsCoefficient(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            typealias M = T.Magnitude
            
            for _ in 0 ..< 32 {
                let a = M.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(T.lsb.power(a, coefficient: b) == Fallible(b))
            }
        }
    }

    @Test(
        "BinaryInteger/exponentiation/edge-cases: base is 0 → 0 or coefficient",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func baseIsZeroYieldsZeroOrCoefficient(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            typealias M = T.Magnitude
            
            for _ in 0 ..< 32 {
                let a = T.zero
                let b = M.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let d = Fallible(b.isZero ? c : T.zero)
                try #require(a.power(b, coefficient: c) == d)
            }
        }
    }

    @Test(
        "BinaryInteger/exponentiation/edge-cases: base is NOT(0) → coefficient * (1 or ~0)",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func baseIsRepeatingOnesYieldsCoefficietExpression(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            typealias M = T.Magnitude
            
            for _ in 0 ..< 32 {
                let a = T(repeating: Bit.one)
                let b = M.entropic(through: Shift.max(or: 255), using: &randomness)
                let c = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let d = c.times(Bool(b.lsb) ? ~0 : 1).veto(!T.isSigned && b >= 2 && !c.isZero)
                try #require(a.power(b, coefficient: c) == d)
            }
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/edge-cases: exponent is 0 → coefficient",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func exponentIsZeroYieldsCoefficientNoError(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(a.power(T.Magnitude.zero, coefficient: b) == Fallible(b))
            }
        }
    }
    
    @Test(
        "BinaryInteger/exponentiation/edge-cases: coefficient is 0 → 0",
        Tag.List.tags(.documentation, .generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func coefficientIsZeroYieldsZeroNoError(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
       
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            for _ in 0 ..< 32 {
                let a = T.entropic(through: Shift.max(or: 255), using: &randomness)
                let b = T.Magnitude.entropic(through: Shift.max(or: 255), using: &randomness)
                try #require(a.power(b, coefficient: T.zero) == Fallible(T.zero))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "BinaryInteger/exponentiation/edge-cases: exponent > Magnitude.max",
        Tag.List.tags(.generic, .random),
        arguments: fuzzers
    )   func exponentsThatDontFitInMagnitude(
        randomness: consuming FuzzerInt
    )   throws {
       
        for small in typesAsSystemsInteger {
            for large in typesAsSystemsInteger {
                try whereIs(small: small, large: large)
            }
        }
        
        func whereIs<A, B>(small: A.Type, large: B.Type)
        throws where A: SystemsInteger, B: SystemsInteger {
            guard A.size < B.size, A.isSigned == B.isSigned else { return }
            
            let min = B.Magnitude(A.Magnitude.max) + 1
            let max = B.Magnitude(B.Magnitude.max)
            
            for _ in 0 ..< 4 {
                let base = A.random(using: &randomness)
                let exponent = B.Magnitude.random(in: min...max, using: &randomness)
                let coefficient = A.random(using: &randomness)
                let small = A(base).power(exponent, coefficient: A(coefficient))
                let large = B(base).power(exponent, coefficient: B(coefficient))
                try #require(small == large.map(A.exactly))
            }
        }
    }
}
