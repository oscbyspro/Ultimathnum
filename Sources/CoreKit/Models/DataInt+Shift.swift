//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Shift x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Ascending
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `0 <= major < self.count`
    ///   - minor: `0 <= minor < IX(size: Element.self)`
    ///
    @inlinable public func upshift(environment: Element, major: IX, minor: IX) {
        if  minor != .zero {
            self.upshift(environment: environment, major: major, minorAtLeastOne: minor)
        }   else if major != .zero {
            self.upshift(environment: environment, majorAtLeastOne: major, minor: Void())
        }
    }
    
    /// Performs an ascending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `1 <= major < self.count`
    ///
    @inlinable public func upshift(environment: Element, majorAtLeastOne major: IX, minor: Void) {
        //=--------------------------------------=
        var destination: IX = self.count
        var source = destination.plus(major.complement()).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 < self.count, String.indexOutOfBounds())
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(raw: destination) > .zero {
            let element:  Element
            
            if  UX(raw: source) > .zero {
                source  = source.decremented().unchecked()
                element = self[unchecked: source]
            }   else {
                element = environment
            }
            
            destination = destination.decremented().unchecked()            
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
    @inlinable public func upshift(environment: Element, major: IX, minorAtLeastOne minor: IX) {
        //=--------------------------------------=
        Swift.assert(000001 <= minor, String.indexOutOfBounds())
        Swift.assert(minor  <  IX(size: Element.self), String.indexOutOfBounds())
        //=--------------------------------------=
        let push = Element(load: UX(raw: minor))
        let pull = push.complement()
        //=--------------------------------------=
        var destination = self.count as IX
        var source = destination.plus(major.toggled()).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 <= ((source)), String.indexOutOfBounds())
        Swift.assert(source <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        var element = self[unchecked: source] as Element
        
        while UX(raw: destination) >  .zero {
            let pushed: Element = element &<< push
            
            if  UX(raw: source) > .zero {
                source  = source.decremented().unchecked()
                element = self[unchecked: source]
            }   else {
                element = environment
            }
            
            let pulled: Element = element &>> pull
            destination = destination.decremented().unchecked()
            self[unchecked: destination] = pushed | pulled
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Descending
    //=------------------------------------------------------------------------=
    
    /// Performs an descending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `0 <= major < self.count`
    ///   - minor: `0 <= minor < IX(size: Element.self)`
    ///
    @inlinable public func downshift(environment: Element, major: IX, minor: IX) {
        if  minor != .zero {
            self.downshift(environment: environment, major: major, minorAtLeastOne: minor)
        }   else if major != .zero {
            self.downshift(environment: environment, majorAtLeastOne: major, minor: Void())
        }
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `1 <= major < self.count`
    ///
    @inlinable public func downshift(environment: Element, majorAtLeastOne major: IX, minor: Void) {
        //=--------------------------------------=
        var destination = IX.zero
        var source = destination.plus(major).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(raw: destination) < UX(raw: self.count)  {
            let element: Element
            
            if  UX(raw: source) <  UX(raw: self.count) {
                element = self[unchecked: source]
                source  = source.incremented().unchecked()
            }   else {
                element = environment
            }
            
            self[unchecked: destination] = element
            destination = destination.incremented().unchecked()
        }
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - environment: The element that fills the void.
    ///   - major: `0 <= major < self.count`
    ///   - minor: `1 <= minor < IX(size: Element.self)`
    ///
    @inlinable public func downshift(environment: Element, major: IX, minorAtLeastOne minor: IX) {
        //=--------------------------------------=
        Swift.assert(00001 <= minor, String.indexOutOfBounds())
        Swift.assert(minor <  IX(size: Element.self), String.indexOutOfBounds())
        //=--------------------------------------=
        let push = Element(load: UX(raw: minor))
        let pull = push.complement()
        //=--------------------------------------=
        var destination = IX.zero
        var source = destination.plus(major).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 <= ((source)), String.indexOutOfBounds())
        Swift.assert(source <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        var element: Element = self[unchecked: source]
        source = source.incremented().unchecked()
        
        while UX(raw: destination) < UX(raw: self.count) {
            let pushed: Element = element &>> push
            
            if  UX(raw: source) <  UX(raw: self.count) {
                element = self[unchecked: source]
                source  = source.incremented().unchecked()
            }   else {
                element = environment
            }
            
            let pulled: Element = element &<< pull
            self[unchecked: destination] = pushed | pulled
            destination = destination.incremented().unchecked()
        }
    }
}
