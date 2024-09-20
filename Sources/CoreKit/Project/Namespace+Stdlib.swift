//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Namespace x Stdlib
//*============================================================================*

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: Swift to/from Ultimathnum conversions should be 1-to-1.
    ///
    /// - Note: We need this method absent custom floating-point models.
    ///
    @inlinable public static func load<Source, Destination>(
        _ source: Source,
        as destination: Destination.Type = Destination.self
    )   -> Destination where Source: Swift.BinaryInteger, Destination: BinaryInteger {
        //=--------------------------------------=
        let words: Source.Words = source.words
        //=--------------------------------------=
        if  Destination.size <= UX.size || words.count <= 1 {
            
            if  Source.isSigned {
                return Destination(load: IX(raw: words.first ?? Swift.UInt.zero))
            }   else {
                return Destination(load: UX(raw: words.first ?? Swift.UInt.zero))
            }
            
        }   else {
            
            return Namespace.withUnsafeBufferPointerOrCopy(of: words) {
                $0.withMemoryRebound(to: UX.self) {
                    Destination(load: DataInt($0, repeating: Source.isSigned ? $0.last!.msb : Bit.zero)!)
                }
            }
        }
    }
}
