//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Elements
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init<T>(load source: T) where T: BitCastable<Element.BitPattern> {
        self.init(low: Low(load: source))
    }

    @inlinable public init<T>(load source: inout ExchangeInt<T, Element.Magnitude>.Stream) {
        //=--------------------------------------=
        let low  = Low (load: &source)
        let high = High(load: &source)
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<Element.BitPattern> {
        self.low.load(as: T.self)
    }
    
    /// ### Development
    ///
    /// - TODO: Improve it.
    ///
    @inlinable public var elements: ExchangeInt<ContiguousArray<Element.Magnitude>, Element.Magnitude> {
        //=--------------------------------------=
        let low  = self.low .elements
        let high = self.high.elements
        //=--------------------------------------=
        return ExchangeInt(ContiguousArray(low.base) + ContiguousArray(high.base), isSigned: Self.isSigned)
    }
}
