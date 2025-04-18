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
// MARK: * Double Int x Loading
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload // this is needed when Element is UX or IX
    @inlinable public init(load source: IX) {
        let low  = Low (load: source)
        let high = High(load: source.down(Low.size))
        self.init(low: low, high: high)
    }
    
    @_disfavoredOverload // this is needed when Element is UX or IX
    @inlinable public init(load source: UX) {
        let low  = Low (load: source)
        let high = High(load: source.down(Low.size))
        self.init(low: low, high: high)
    }
    
    @_disfavoredOverload // this is needed when Element is UX or IX
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        let low  = UX(load: self.storage.low )
        let high = UX(load: self.storage.high).up(Low.size)
        return UX.BitPattern(raw: low  | high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public init(load source: consuming  Element.Magnitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.storage.low.load(as: Element.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: DataInt<U8>) {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source[UX(raw: MemoryLayout<Low>.stride)...])
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    @inlinable public init(load source: DataInt<Element.Magnitude>) {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source[(UX(size: Low.self) / UX(size: Element.Magnitude.self))...])
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
}
