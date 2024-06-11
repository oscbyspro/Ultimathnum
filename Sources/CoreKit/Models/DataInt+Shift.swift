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
    ///   - major: `0 <= major < self.count`
    ///   - minor: `0 <= minor < IX(size: Element.self)`
    ///   - environment: The element that fills the void.
    ///
    @inlinable public func upshift(major: IX, minor: IX, environment: Element = .zero) {
        if !minor.isZero {
            self.upshift(major: major, minorAtLeastOne: minor, environment: environment)
        }   else if !major.isZero {
            self.upshift(majorAtLeastOne: major, minor: (( )), environment: environment)
        }
    }
    
    /// Performs an ascending shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < self.count`
    ///   - environment: The element that fills the void.
    ///
    @inline(never) @inlinable public func upshift(majorAtLeastOne major: IX, minor: Void, environment: Element = .zero) {
        //=--------------------------------------=
        var destination: IX = self.count
        var source = destination.plus(major.complement()).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 < self.count, String.indexOutOfBounds())
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(raw: destination) > .zero {
            let element: Element
            
            if  UX(raw: source) > .zero {
                source  = source.decremented().unchecked()
                element = self[unchecked: source]
            }   else {
                element = environment as Element
            }
            
            destination = destination.decremented().unchecked()            
            self[unchecked: destination] = element
        }
    }
    
    /// Performs an ascending shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.count`
    ///   - minor: `1 <= minor < IX(size: Element.self)`
    ///   - environment: The element that fills the void.
    ///
    @inline(never) @inlinable public func upshift(major: IX, minorAtLeastOne minor: IX, environment: Element = .zero) {
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
        
        while UX(raw: destination) > .zero {
            let pushed: Element = element &<< push
            
            if  UX(raw: source) > .zero {
                source  = source.decremented().unchecked()
                element = self[unchecked: source]
            }   else {
                element = environment as Element
            }
            
            let pulled: Element = element &>> pull
            destination = destination.decremented().unchecked()
            self[unchecked: destination] = pushed | pulled
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Descending
    //=------------------------------------------------------------------------=
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.count`
    ///   - minor: `0 <= minor < IX(size: Element.self)`
    ///   - environment: The element that fills the void.
    ///
    @inlinable public func downshift(major: IX, minor: IX, environment: Element = .zero) {
        if !minor.isZero {
            self.downshift(major: major, minorAtLeastOne: minor, environment: environment)
        }   else if !major.isZero {
            self.downshift(majorAtLeastOne: major, minor: (( )), environment: environment)
        }
    }
    
    /// Performs a descending shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < self.count`
    ///   - environment: The element that fills the void.
    ///
    @inline(never) @inlinable public func downshift(majorAtLeastOne major: IX, minor: Void, environment: Element = .zero) {
        //=--------------------------------------=
        var destination = IX.zero
        var source = destination.plus(major).unchecked()
        //=--------------------------------------=
        Swift.assert(000000 < ((source)), String.indexOutOfBounds())
        Swift.assert(source < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        while UX(raw: destination) < UX(raw: self.count)  {
            let element: Element
            
            if  UX(raw: source) < UX(raw: self.count) {
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
    ///   - major: `0 <= major < self.count`
    ///   - minor: `1 <= minor < IX(size: Element.self)`
    ///   - environment: The element that fills the void.
    ///
    @inline(never) @inlinable public func downshift(major: IX, minorAtLeastOne minor: IX, environment: Element = .zero) {
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
            
            if  UX(raw: source) < UX(raw: self.count) {
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
