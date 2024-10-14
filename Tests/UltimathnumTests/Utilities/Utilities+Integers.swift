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
// MARK: * Utilities x Integers
//*============================================================================*

@Suite struct UtilitiesTestsOnIntegers {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("BinaryInteger.entropic(through:as:using:) - max index for each domain", arguments: i8u8, fuzzers)
    func entropicThroughMaxIndexForEachDomain(type: any SystemsInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.binary,  is: Set(T.all))
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.finite,  is: Set(T.all))
            Ɣexpect(entropic: &randomness, through: Shift.max, as: Domain.natural, is: Set(T.nonnegatives))
        }
    }
    
    @Test("BinaryInteger.entropic(through:as:using:) - small indices for each domain", arguments: typesAsBinaryInteger, fuzzers)
    func entropicThroughSmallIndicesForEachDomain(type: any BinaryInteger.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
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
}
