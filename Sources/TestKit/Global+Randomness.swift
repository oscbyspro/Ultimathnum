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
// MARK: * Global x Randomness
//*============================================================================*

public let random = RandomInt()

public let fuzzer = FuzzerInt.random()

public let fuzzers: [FuzzerInt] = [fuzzer]

public let randomnesses: [any Randomness & Sendable] = [random, fuzzer]
