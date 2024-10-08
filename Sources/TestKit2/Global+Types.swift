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
// MARK: * Global x Types
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Integers
//=----------------------------------------------------------------------------=

public let i8u8: [any CoreInteger.Type] = [
    I8.self,
    U8.self,
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
// MARK: + Floats
//=----------------------------------------------------------------------------=

public let allSwiftBinaryFloatingPointTypes: [any Swift.BinaryFloatingPoint.Type] = [
    Float32.self,
    Float64.self,
]
