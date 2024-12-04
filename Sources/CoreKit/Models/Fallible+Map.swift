//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Map
//*============================================================================*

extension Fallible {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Transforms the `value` using the given `map` function and merges the
    /// result with the current `error` indicator as well as any `error` indicators
    /// returned by the given `map` function.
    ///
    @inlinable public consuming func map<Mapped, Error>(
        _ map: (Value) throws(Error) -> Mapped
    )   throws (Error) -> Fallible<Mapped> {
        Fallible<Mapped>(try map(self.value), error: self.error)
    }
    
    /// Transforms the `value` using the given `map` function and merges the
    /// result with the current `error` indicator as well as any `error` indicators
    /// returned by the given `map` function.
    ///
    /// ### Development
    ///
    /// `Optional<T>` calls this operation `flatMap(_:)`. This distinction lets
    /// you return `Optional<Optional<T>>` from the ordinary `map(_:)`. I'm not
    /// yet convinced that's desirable, however. Still, I may rename it.
    ///
    @inlinable public consuming func map<Mapped, Error>(
        _ map: (Value) throws(Error) -> Fallible<Mapped>
    )   throws (Error) -> Fallible<Mapped> {
        try map(self.value).veto(self.error)
    }
}
