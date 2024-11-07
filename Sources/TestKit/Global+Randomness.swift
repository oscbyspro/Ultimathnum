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

public var random = RandomInt()

public let fuzzer = FuzzerInt(seed: random.next())

public let randomnesses: [any Randomness] = [random, fuzzer]

public let fuzzers: [FuzzerInt] = [fuzzer]
