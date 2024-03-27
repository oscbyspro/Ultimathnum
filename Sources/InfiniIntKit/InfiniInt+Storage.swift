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
// MARK: * Infini Int x Storage
//*============================================================================*

extension InfiniInt { @usableFromInline typealias Storage = BitPattern._Storage }

//*============================================================================*
// MARK: * Infini Int x Storage x Unsigned
//*============================================================================*

extension InfiniInt where Element == Element.Magnitude {
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    /// ### Development
    ///
    /// - TODO: This is a minimum viable product. Improve it at some point.
    ///
    @frozen @usableFromInline struct _Storage: Hashable {
        
        @usableFromInline typealias Base = ContiguousArray<Element>
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        /// The un/signed source.
        public var base: Base
        
        /// The bit extension of the un/signed source.
        public var appendix: BitExtension<Element>
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ base: Base, repeating appendix: BitExtension<Element>) {
            self.base = base
            self.appendix = appendix
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable var isNormal: Bool {
            self.base.last != self.appendix.element
        }
        
        @inlinable mutating func normalize() {
            while self.base.last == self.appendix.element {
                ((self.base)).removeLast()
            }
        }
    }
}
