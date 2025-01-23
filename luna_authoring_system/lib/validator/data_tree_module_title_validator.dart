import 'package:luna_authoring_system/pptx_data_objects/pptx_tree.dart';
import 'package:luna_authoring_system/validator/exception/authoring_system_data_tree_validation_exception.dart';
import 'package:luna_authoring_system/validator/interface/i_data_tree_validator.dart';

/// A validator that checks the validity of the title of a `PptxTree`.
///
/// This class implements the `IDataTreeValidator` and ensures that the
/// title of the associated `PptxTree` is not empty. If the title is empty,
/// it throws an `AuthoringSystemDataTreeValidationException` with a specific message.
class DataTreeModuleTitleValidator implements IDataTreeValidator {
    final PptxTree _dataTree;

    /// Constructs a `DataTreeModuleTitleValidator` with a [PptxTree].
    ///
    /// The provided [dataTree] is the `PptxTree` instance that the validator will check.
    /// It must not be null.
    DataTreeModuleTitleValidator(this._dataTree);

    /// Validates the title of the `_dataTree`.
    ///
    /// Returns `true` if the title is not empty, indicating the validation passed.
    /// Throws an [AuthoringSystemDataTreeValidationException] if the title is empty
    /// with the message "Title cannot be empty".
    @override
    bool validate() {
        if (_dataTree.title.isEmpty) {
            throw AuthoringSystemDataTreeValidationException("Data Tree Module Title cannot be empty");
        }
        
        return true;
    }
}
