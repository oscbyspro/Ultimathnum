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
// MARK: * Aliases
//*============================================================================*

public typealias ArbitraryIntegerWhereIsSigned   = ArbitraryInteger &   SignedInteger
public typealias ArbitraryIntegerWhereIsUnsigned = ArbitraryInteger & UnsignedInteger
public typealias      CoreIntegerWhereIsSigned   =      CoreInteger &   SignedInteger
public typealias      CoreIntegerWhereIsUnsigned =      CoreInteger & UnsignedInteger
public typealias      EdgyIntegerWhereIsSigned   =      EdgyInteger &   SignedInteger
public typealias      EdgyIntegerWhereIsUnsigned =      EdgyInteger & UnsignedInteger
public typealias   SystemsIntegerWhereIsSigned   =   SystemsInteger &   SignedInteger
public typealias   SystemsIntegerWhereIsUnsigned =   SystemsInteger & UnsignedInteger
