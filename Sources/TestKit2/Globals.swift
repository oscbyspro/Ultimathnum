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

//*============================================================================*
// MARK: * Globals
//*============================================================================*

public let coreFloats: [any Swift.BinaryFloatingPoint.Type] = [
    Float32.self,
    Float64.self,
]

public let coreIntegers: [any CoreInteger.Type] = {
    coreIntegersWhereIsSigned +
    coreIntegersWhereIsUnsigned
}()

public let coreIntegersWhereIsSigned: [any CoreIntegerWhereIsSigned.Type] = [
    IX.self, I8.self, I16.self, I32.self, I64.self,
]

public let coreIntegersWhereIsUnsigned: [any CoreIntegerWhereIsUnsigned.Type] = [
    UX.self, U8.self, U16.self, U32.self, U64.self,
]

//=----------------------------------------------------------------------------=
// MARK: + Randomness
//=----------------------------------------------------------------------------=

public var random = RandomInt()

public let fuzzer = FuzzerInt(seed: random.next())

public let randomnesses: [any Randomness] = [random, fuzzer]

//=----------------------------------------------------------------------------=
// MARK: + Data
//=----------------------------------------------------------------------------=

/// A collection of all primes that fit in one byte.
///
/// - Note: It contains `54` elements.
///
public let primes54: [U8] = [
    0002, 0003, 0005, 0007, 0011, 0013, 0017, 0019,
    0023, 0029, 0031, 0037, 0041, 0043, 0047, 0053,
    0059, 0061, 0067, 0071, 0073, 0079, 0083, 0089,
    0097, 0101, 0103, 0107, 0109, 0113, 0127, 0131,
    0137, 0139, 0149, 0151, 0157, 0163, 0167, 0173,
    0179, 0181, 0191, 0193, 0197, 0199, 0211, 0223,
    0227, 0229, 0233, 0239, 0241, 0251
]
