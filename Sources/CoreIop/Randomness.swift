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
// MARK: * Randomness
//*============================================================================*

/// An interoperable source of uniformly distributed random data.
public protocol RandomnessInteroperable: Interoperable, Randomness where Stdlib: Swift.RandomNumberGenerator { }
