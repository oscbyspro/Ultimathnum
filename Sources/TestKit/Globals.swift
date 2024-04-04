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
// MARK: * Globals
//*============================================================================*

public let coreSystemsIntegers: [any SystemsInteger.Type] = {
    coreSystemsIntegersWhereIsSigned +
    coreSystemsIntegersWhereIsUnsigned
}()

public let coreSystemsIntegersWhereIsSigned: [any (SystemsInteger & SignedInteger).Type] = [
    IX.self, I8.self, I16.self, I32.self, I64.self,
]

public let coreSystemsIntegersWhereIsUnsigned: [any (SystemsInteger & UnsignedInteger).Type] = [
    UX.self, U8.self, U16.self, U32.self, U64.self,
]
