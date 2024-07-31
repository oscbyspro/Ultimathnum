//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Namespace
//*============================================================================*

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@frozen public enum Namespace {
    
    /// A protocol used to manipulate the reduction order.
    ///
    /// See also: Slava Pestov's forum [post][1].
    ///
    /// [1]: https://forums.swift.org/t/fixedwidth-cannot-build-rewrite-system-for-protocol/64285/7
    ///
    public protocol Foo { }
    
    /// A protocol used to manipulate the reduction order.
    ///
    /// See also: Slava Pestov's forum [post][1].
    ///
    /// [1]: https://forums.swift.org/t/fixedwidth-cannot-build-rewrite-system-for-protocol/64285/7
    ///
    public protocol Bar { }
}
