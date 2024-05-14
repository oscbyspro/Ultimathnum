//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Platform
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Endianness
//=----------------------------------------------------------------------------=

#if _endian(little)
public typealias MachineByteOrder = Ascending
#elseif _endian(big)
public typealias MachineByteOrder = Descending
#else
public typealias MachineByteOrder = Never
#endif

//=----------------------------------------------------------------------------=
// MARK: + Text
//=----------------------------------------------------------------------------=

#if $Embedded
public typealias   MaybeCustomStringConvertible = Any
public typealias MaybeLosslessStringConvertible = Any
#else
public typealias   MaybeCustomStringConvertible =   CustomStringConvertible
public typealias MaybeLosslessStringConvertible = LosslessStringConvertible
#endif
