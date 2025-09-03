// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:luna_authoring_system/controllers/module_build_service.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_authoring_system/translator/csv_export_use_case.dart';
import 'package:luna_authoring_system/user_interface/validation_issues_summary.dart';
import 'package:luna_authoring_system/validator/translator_validators/translated_csv_validator.dart';
import 'package:luna_core/models/module.dart';
import 'package:provider/provider.dart';

/// Home page for the Authoring System
/// Goes through each input for the system
/// Once all inputs are selected, converts the specified input file to a .luna
class AuthoringHomeScreen extends StatefulWidget {
  @override
  _AuthoringHomeScreenState createState() => _AuthoringHomeScreenState();
}

class _AuthoringHomeScreenState extends State<AuthoringHomeScreen> {
  String? filePath;
  bool filePicked = false;
  bool textEntered = false;

  // State & helpers
  Module? _builtModule;
  final CsvExportUseCase _csvUseCase = CsvExportUseCase();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;

  final TextEditingController _controller = TextEditingController();
  final store = ValidationIssuesStore();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pptx'],
      withData: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        filePath = result.files.single.path!;
        filePicked = true;
        textEntered = false;
        _builtModule = null; // reset if new file is picked
      });
    }
  }

  Future<void> _submitText() async {
    // Guard rails
    if (!filePicked || filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a .pptx file first.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    try {
      final service = ModuleBuildService(store);
      final name = _controller.text.trim();

      // parse, validate, construct module.
      late Module module;
      try {
        module = await service.build(filePath!, name);
      } on StateError catch (_) {
        // Validation issues present; UI will show them via store.
        setState(() {
          textEntered = false;
          _builtModule = null;
        });
        return;
      }

      // Saving the module via ModuleResourceFactory
      await service.save(name, module);

      setState(() {
        _builtModule = module; // for CSV export
        textEntered = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conversion failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv() async {
    if (_builtModule == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Module available to export.')),
      );
      return;
    }

    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save CSV as...',
      fileName:
          '${_controller.text.trim().isEmpty ? "module" : _controller.text.trim()}.csv',
      type: FileType.custom,
      allowedExtensions: const ['csv'],
    );
    if (savePath == null) return;

    setState(() => _busy = true);
    try {
      final ok = await _csvUseCase.exportModuleToCsv(
        module: _builtModule!,
        outputFilePath: savePath,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'CSV saved.' : 'CSV save failed.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV export failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Validate a user-picked translated CSV and surface issues in [store].
  Future<void> _validateTranslatedCsv() async {
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        withData: true,
      );
      if (picked == null) return;

      // Read CSV text from bytes or file path
      final file = picked.files.single;
      String csvText;
      if (file.bytes != null) {
        csvText = utf8.decode(file.bytes!);
      } else {
        csvText = await File(file.path!).readAsString();
      }

      // Run validator and update store
      store.clear();
      final issues = TranslatedCsvValidator(csvText).validate();
      for (final i in issues) {
        store.addIssue(i);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            issues.isEmpty
                ? 'No validation issues found.'
                : 'Validation Issues Found: ${issues.length}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Validation failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => store,
      child: Scaffold(
        appBar: AppBar(title: const Text("Luna Authoring System")),
        body: Consumer<ValidationIssuesStore>(
          builder: (context, store, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!filePicked)
                        ElevatedButton(
                          onPressed: _busy ? null : _pickFile,
                          child: const Text("Pick a PPTX File"),
                        ),

                      if (filePicked && !textEntered) ...[
                        Text("File Selected: $filePath"),
                        const SizedBox(height: 12),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            controller: _controller,
                            enabled: !_busy,
                            decoration: const InputDecoration(
                              labelText: "Enter Module Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              final s = (v ?? '').trim();
                              if (s.isEmpty) return 'Module name is required';
                              if (!RegExp(r'^[A-Za-z0-9 _\.-]{3,}$')
                                  .hasMatch(s)) {
                                return 'Use 3+ chars: letters, numbers, space, _ . -';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitText(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _busy ? null : _submitText,
                          child: _busy
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Submit"),
                        ),
                      ],

                      if (textEntered && !store.hasIssues) ...[
                        const SizedBox(height: 8),
                        const Text("Job done!", style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _busy ? null : _exportCsv,
                              icon: const Icon(Icons.save_alt),
                              label: const Text('Export CSV'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _busy ? null : _validateTranslatedCsv,
                              icon: const Icon(Icons.fact_check),
                              label: const Text('Validate Translated CSV'),
                            ),
                          ],
                        ),
                      ],

                      if (store.hasIssues) ...[
                        const SizedBox(height: 20),
                        ValidationIssuesSummary(
                          issues: store.issues,
                          store: store,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _busy ? null : _validateTranslatedCsv,
                          icon: const Icon(Icons.fact_check),
                          label: const Text('Validate Translated CSV'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
