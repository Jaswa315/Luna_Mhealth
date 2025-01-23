// This file defines the IDataTreeValidator interface.

abstract class IDataTreeValidator {
  // Constructor definition if needed, which could include passing data structures such as PptxTree.
  // Dart doesn't support constructors in interfaces directly, so you won't define one here.
  // Instead, ensure implementing classes include constructors that accept necessary parameters.

  // Define the validate method that all validators must implement.
  bool validate();
}
