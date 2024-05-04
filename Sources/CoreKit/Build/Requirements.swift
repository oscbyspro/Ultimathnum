//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Requirements
//*============================================================================*

#if _endian(little)

#else
#error("Ultimathnum does not yet support big endian platforms.")
#endif

#if $Embedded
public typealias   MaybeCustomStringConvertible = Any
public typealias MaybeLosslessStringConvertible = Any
#else
public typealias   MaybeCustomStringConvertible =   CustomStringConvertible
public typealias MaybeLosslessStringConvertible = LosslessStringConvertible
#endif
