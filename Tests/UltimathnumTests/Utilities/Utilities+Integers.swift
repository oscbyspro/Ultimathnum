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
import TestKit

//*============================================================================*
// MARK: * Utilities x Integers
//*============================================================================*

@Suite struct UtilitiesTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Utilities/integers: entropic through max index for each domain",
        Tag.List.tags(.generic, .random),
        arguments: typesAsCoreIntegerAsByte, fuzzers
    )   func entropicThroughMaxIndexForEachDomainAsByte(
        type: any SystemsInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: SystemsInteger {
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.binary,  is: Set(T.all))
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.finite,  is: Set(T.all))
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.natural, is: Set(T.nonnegatives))
        }
    }
    
    @Test(
        "Utilities/integers: entropic through small indices for each domain",
        Tag.List.tags(.generic, .random),
        arguments: typesAsBinaryInteger, fuzzers
    )   func entropicThroughSmallIndicesForEachDomain(
        type: any BinaryInteger.Type, randomness: consuming FuzzerInt
    )   throws {
        
        try  whereIs(type)
        func whereIs<T>(_ type: T.Type) throws where T: BinaryInteger {
            if  T.isSigned {
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.binary,  is: [    -1,  0    ] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.finite,  is: [    -1,  0    ] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.natural, is: [         0    ] as Set<T>)
                
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.binary,  is: [-2, -1,  0,  1] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.finite,  is: [-2, -1,  0,  1] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.natural, is: [         0,  1] as Set<T>)
            }   else {
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.binary,  is: [ 0,         ~0] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.finite,  is: [ 0,  1        ] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.min, as: Domain.natural, is: [ 0,  1        ] as Set<T>)
                
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.binary,  is: [ 0,  1, ~1, ~0] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.finite,  is: [ 0,  1,  2,  3] as Set<T>)
                Ɣexpect(entropic: &randomness, through: Shift.one, as: Domain.natural, is: [ 0,  1,  2,  3] as Set<T>)
            }
        }
    }
    
    private func Ɣexpect<T>(
        entropic randomness: inout some Randomness,
        through index: Shift<T.Magnitude>,
        as domain: Domain,
        is expectation: Set<T>,
        at location: SourceLocation = #_sourceLocation
    )   where T: BinaryInteger {
        var result = Set<T>()
        
        while result.count < expectation.count {
            for _ in 000 ..< expectation.count {
                result.insert(T.entropic(through: index, as: domain, using: &randomness))
            }
        }
        
        #expect(result == expectation, sourceLocation: location)
    }
}
