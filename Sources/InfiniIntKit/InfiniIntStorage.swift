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
// MARK: * Infini Int Storage
//*============================================================================*

@frozen @usableFromInline struct InfiniIntStorage<Element>: Hashable 
where Element: SystemsInteger & UnsignedInteger {
    
    @usableFromInline typealias Body = ContiguousArray<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var body: Body
    
    @usableFromInline var appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ body: consuming Body, repeating appendix: Bit) {
        self.body = body
        self.appendix = appendix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: IX {
        IX(self.body.count)
    }
    
    @inlinable public var small: Small? {
        if  self.body.count >= 2 {
            return nil
        }   else if self.body.count == 1 {
            let element = self.body[.zero]
            return Small(element, repeating: self.appendix)
        }   else {
            let element = Element(repeating: self.appendix)
            return Small(element, repeating: self.appendix)
        }
    }
    
    //*========================================================================*
    // MARK: * Small
    //*========================================================================*
    
    /// ### Development
    ///
    /// Consider an un/signed element only.
    ///
    @frozen public struct Small {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var body: Element
        
        @usableFromInline var appendix: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ body: Element, repeating appendix: Bit) {
            self.body = body
            self.appendix = appendix
        }
    }
}
