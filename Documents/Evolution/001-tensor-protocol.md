# Tensor Protocol

* Proposal: [001](https://github.com/nifty-swift/Nifty/blob/master/Documents/Evolution/001-tensor-protocol.md)
* Author: Felix Fischer
* Status: **Draft**

## Introduction

This proposal refactors all of the existing *Tensor*-derived types into a single protocol with a default implementation.

## Motivation

By *Tensor*-derived types, I refer to all of the types that are based on the more general concept of *Tensor*. In our current implementation, these are `Matrix`, `Vector` and `Tensor` itself.

There is an extensive repetition of code between them, as can be seen here:

```swift

@Tensor
    /// Number of elements in the tensor.
    public let count: Int

    /// Number of elements in each dimension of the tensor.
    public var size: [Int]

    /// Data contained in tensor in row-major order.
    public var data: [T]

    /// Optional name of tensor (e.g., for use in display).
    public var name: String?

    /// Determine whether to show name when displaying tensor.
    public var showName: Bool

    /// Formatter to be used in displaying tensor elements.
    public var format: NumberFormatter
@Matrix
    /// Number of elements in the matrix.
    public let count: Int

    /// Number of [rows, columns] in the matrix.
    public var size: [Int]
    public var rows: Int { return self.size[0] }
    public var columns: Int { return self.size[1] }

    /// Data contained in matrix in row-major order.
    public var data: [T]

    /// Optional name of matrix (e.g., for use in display).
    public var name: String?

    /// Determine whether to show name when displaying matrx.
    public var showName: Bool

    /// Formatter to be used in displaying matrix elements.
    public var format: NumberFormatter    

@Vector
    /// Number of elements in vector.
    public let count: Int

    /// Data contained in vector.
    public var data: [T]

    /// Optional name of vector for use in display
    public var name: String?

    /// Determine whether to show name when displaying matrx.
    public var showName: Bool

    /// Formatter to be used in displaying matrix elements.
    public var format: NumberFormatter

```

This implementation has two important problems:

1. Duplication of code leads to bugs. *And bugs lead to the dark side...?*
2. We're not making the most out of the types we use, since what they have in common is not reflected in their relationship with one another. Such relationships could be used to reutilize tests and generic algorithms.

This proposal addresses both of them, at least partially.

## Proposed solution

We propose a **new protocol**, called `TensorProtocol`, and an **extension** that allows for default behavior to be present.

Current *Tensor*-derived types would conform to this protocol. This makes the following true:

They explicity state that they are *Tensors*. This makes them usable as *TensorProtocol* objects. They would also inherit the default behavior, and be able to override it where it makes sense. 

Finally of course, they can extend the protocol's functionality. This allows us to not lose the current space for design now and in the future for types that would conform to the protocol.

## Detailed design

//WIP

## Impact on existing code

//TBD

## Alternatives considered

//WIP
