//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Shift x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Ascending
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `1 <= major < self.count`
    ///
    @inlinable public func upshift(environment: Element, majorAtLeastOne major: Index) {
        //=--------------------------------------=
        var destination: Index = self.count
        var source = destination.plus(major.complement()).assert()
        //=--------------------------------------=
        Swift.assert(000000 < self.count, String.indexOutOfBounds())
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(bitPattern: destination) > .zero {
            let element:  Element
            
            if  UX(bitPattern: source) > .zero {
                source[{ $0.decremented().assert() }]
                element = self[unchecked: source]
            }   else {
                element = environment
            }
            
            destination[{ $0.decremented().assert() }]
            self[unchecked: destination] = element
        }
    }
    
    /// Performs a ascending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `0 <= major < self.count`
    ///   - minor: `1 <= minor < IX(size: Element.self)`
    ///
    @inlinable public func upshift(environment: Element, major: Index, minorAtLeastOne minor: Index) {
        //=--------------------------------------=
        Swift.assert(000001 <= minor, String.indexOutOfBounds())
        Swift.assert(minor  <  IX(size: Element.self), String.indexOutOfBounds())
        //=--------------------------------------=
        let push = Element(load: UX(bitPattern: minor))
        let pull = push.complement()
        //=--------------------------------------=
        var destination = self.count as Index
        var source = destination.plus(major.toggled()).assert()
        //=--------------------------------------=
        Swift.assert(000000 <= ((source)), String.indexOutOfBounds())
        Swift.assert(source <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        var element = self[unchecked: source] as Element
        
        while UX(bitPattern: destination) >  .zero {
            let pushed: Element = element &<< push
            
            if  UX(bitPattern: source) > .zero {
                source[{ $0.decremented().assert() }]
                element = self[unchecked: source]
            }   else {
                element = environment
            }
            
            let pulled: Element = element &>> pull
            destination[{ $0.decremented().assert() }]
            self[unchecked: destination] = pushed | pulled
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Descending
    //=------------------------------------------------------------------------=
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `1 <= major < self.count`
    ///
    @inlinable public func downshift(environment: Element, majorAtLeastOne major: Index) {
        //=--------------------------------------=
        var destination = Index.zero
        var source = destination.plus(major).assert()
        //=--------------------------------------=
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(bitPattern: destination) < UX(bitPattern: self.count)  {
            let element: Element
            
            if  UX(bitPattern: source) <  UX(bitPattern: self.count) {
                element = self[unchecked: source]
                source[{ $0.incremented().assert() }]
            }   else {
                element = environment
            }
            
            self[unchecked: destination] = element
            destination[{ $0.incremented().assert() }]
        }
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `0 <= major < self.count`
    ///   - minor: `1 <= minor < IX(size: Element.self)`
    ///
    @inlinable public func downshift(environment: Element, major: Index, minorAtLeastOne minor: Index) {
        //=--------------------------------------=
        Swift.assert(00001 <= minor, String.indexOutOfBounds())
        Swift.assert(minor <  IX(size: Element.self), String.indexOutOfBounds())
        //=--------------------------------------=
        let push = Element(load: UX(bitPattern: minor))
        let pull = push.complement()
        //=--------------------------------------=
        var destination = Index.zero
        var source = destination.plus(major).assert()
        //=--------------------------------------=
        Swift.assert(000000 <= ((source)), String.indexOutOfBounds())
        Swift.assert(source <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        var element: Element = self[unchecked: source]
        source[{ $0.incremented().assert() }]
        
        while UX(bitPattern: destination) < UX(bitPattern: self.count) {
            let pushed: Element = element &>> push
            
            if  UX(bitPattern: source) <  UX(bitPattern: self.count) {
                element = self[unchecked: source]
                source[{ $0.incremented().assert() }]
            }   else {
                element = environment
            }
            
            let pulled: Element = element &<< pull
            self[unchecked: destination] = pushed | pulled
            destination[{ $0.incremented().assert() }]
        }
    }
}
