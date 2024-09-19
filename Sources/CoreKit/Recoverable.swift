//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Recoverable
//*============================================================================*

/// A redemption arc.
///
/// A recoverable type is essentially any type designed to propagate through
/// the `Fallible<Value>` recovery metchanism. Such types should not have any
/// independent failure modes.
///
public protocol Recoverable { }
