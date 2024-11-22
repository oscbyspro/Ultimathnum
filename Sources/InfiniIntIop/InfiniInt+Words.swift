//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Infini Int x Words x Stdlib
//*============================================================================*

extension InfiniInt.Stdlib {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        consuming get {
            Words(self.base)
        }
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: Swift.CustomStringConvertible, Swift.RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable internal init(_ base: consuming Base) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var description: String {
            "[\(self.lazy.map({ $0.description }).joined(separator: ", "))]"
        }
        
        @inlinable public var startIndex: Swift.Int {
            Swift.Int.zero
        }
        
        @inlinable public var endIndex: Swift.Int {
            self.count as Swift.Int
        }
        
        @inlinable public var count: Swift.Int {
            if  Base.Element.size >= UX.size {
                self.base.withUnsafeBinaryIntegerElements(as: UX.self) {
                    Swift.Int($0.body.count + IX(Bit($0.body.last?.msb != $0.appendix)))
                }
                
            }   else {
                self.base.withUnsafeBinaryIntegerElements(as: U8.self) {
                    let divisor = Nonzero(unchecked: UX(raw: MemoryLayout<UX>.size))
                    var division: Division = UX(raw: $0.body.count).division(divisor)
                    if !division.remainder.isZero {
                        division.quotient &+= 1
                    }   else {
                        division.quotient &+= UX(Bit($0.body.last?.msb != $0.appendix))
                    }
                    
                    return Swift.Int(raw: division.quotient)
                }
            }
        }
        
        @inlinable public subscript(index: Swift.Int) -> Swift.UInt {
            if  Base.Element.size >= UX.size {
                self.base.withUnsafeBinaryIntegerElements(as: UX.self) {
                    Swift.UInt($0[UX(IX(index))])
                }
                
            }   else {
                self.base.withUnsafeBinaryIntegerElements(as: U8.self) {
                    let ratio = UX(raw: MemoryLayout<UX>.size)
                    let start = UX(IX(index)).times(ratio).optional() ?? UX.max
                    return Swift.UInt($0[start...].load(as: UX.self))
                }
            }
        }
    }
}
