//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntIop
import InfiniIntKit

//*============================================================================*
// MARK: * Utilities x Globals
//*============================================================================*
// Imagine an array of chosen types and a bunch of type filters...
//=----------------------------------------------------------------------------=

let typesAsInfiniIntStdlib: [any InfiniIntStdlib.Type] = [
    InfiniInt<I8>.Stdlib.self,
    InfiniInt<IX>.Stdlib.self,
]
