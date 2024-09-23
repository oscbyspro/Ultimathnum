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
// MARK: * Core Integer
//*============================================================================*

/// ### Development
///
/// - TODO: Consider adding a public version to `CoreKit`.
///
public protocol CoreInteger:
    Interoperable,
    SystemsInteger
where
    BitPattern == Stdlib.BitPattern,
    Element == Self,
    IntegerLiteralType == Stdlib,
    Magnitude: CoreInteger,
    Signitude: CoreInteger,
    Stdlib: BitCastable,
    Stdlib: Swift.FixedWidthInteger,
    Stdlib: Swift.Sendable,
    Stdlib.BitPattern == Stdlib.Magnitude,
    Stdlib.Magnitude  == Magnitude.Stdlib
{ }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias CoreIntegerWhereIsSigned   = CoreInteger &   SignedInteger
public typealias CoreIntegerWhereIsUnsigned = CoreInteger & UnsignedInteger

//=----------------------------------------------------------------------------=
// MARK: + Models
//=----------------------------------------------------------------------------=

extension IX:  CoreInteger { }
extension I8:  CoreInteger { }
extension I16: CoreInteger { }
extension I32: CoreInteger { }
extension I64: CoreInteger { }

extension UX:  CoreInteger { }
extension U8:  CoreInteger { }
extension U16: CoreInteger { }
extension U32: CoreInteger { }
extension U64: CoreInteger { }
