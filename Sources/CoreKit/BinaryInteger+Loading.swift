//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Loading
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Loads the bit pattern of `body` and `appendix` that fits.
    @inlinable public init<Body: Contiguous>(
        load body: borrowing Body,
        repeating appendix: Bit = Bit.zero
    )   where Body.Element: SystemsInteger & UnsignedInteger {
        
        self = body.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: Body.Element.Element.self) {
                Self(load: DataInt($0, repeating: appendix)!)
            }
        }
    }
    
    /// Loads the bit pattern of `source` that fits.
    @inlinable public init<OtherElement>(load source: DataInt<OtherElement>) {
        if  Self.Element.size <= OtherElement.size {
            self = source.reinterpret(as: Self.Element.Magnitude.self, perform: Self.init(load:))
        }   else {
            self = source.reinterpret(as: U8.self, perform: Self.init(load:))
        }
    }
    
    /// Loads the bit pattern of `source` that fits.
    @inlinable public init<Other>(load source: borrowing Other) where Other: BinaryInteger {
        if  Other.size <= Swift.min(Element.size, UX.size) {
            
            if  Other.isSigned {
                self.init(load: Element.Signitude(load: IX(load: source)))
            }   else {
                self.init(load: Element.Magnitude(load: UX(load: source)))
            }
            
        }   else if (Self.size <= UX.size) || (Other.size <= UX.size) {
            
            if  Other.isSigned {
                self.init(load: IX(load: source))
            }   else {
                self.init(load: UX(load: source))
            }
            
        }   else {
            self = source.withUnsafeBinaryIntegerElements(Self.init(load:))
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Loading x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    ///
    /// - Note: This is the generic version of `BinaryInteger/load(as:)`.
    ///
    @inlinable public init<Other>(load source: borrowing Other)
    where Other: BinaryInteger, BitPattern == Other.Element.BitPattern {
        self.init(raw: source.load(as: BitPattern.self))
    }
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    ///
    /// - Note: This is the generic version of `BinaryInteger/load(as:)`.
    ///
    @inlinable public init<Other>(load source: borrowing Other)
    where Other: BinaryInteger, BitPattern == UX.BitPattern {
        self.init(raw: source.load(as: BitPattern.self))
    }
    
    /// Creates a new instance from the bit pattern of `source` that fits.
    ///
    /// - Note: This is the generic version of `BinaryInteger/load(as:)`.
    ///
    @inlinable public init<Other>(load source: borrowing Other)
    where Other: BinaryInteger, BitPattern == Other.Element.BitPattern, BitPattern == UX.BitPattern {
        let source: some BinaryInteger = copy source
        self.init(raw: source.load(as: BitPattern.self))
    }
}
