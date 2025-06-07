import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CouponRegisterScreen extends StatefulWidget {
  const CouponRegisterScreen({super.key});

  @override
  State<CouponRegisterScreen> createState() => _CouponRegisterScreenState();
}

class _CouponRegisterScreenState extends State<CouponRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _memoController = TextEditingController();
  String? _selectedFolder;
  bool _enableAlarm = false;
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final loc = AppLocalizations.of(context)!;
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(loc.imageSelect),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                child: Text(loc.camera),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                child: Text(loc.library),
              ),
            ],
          ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    final loc = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(loc.couponRegisterTitle),
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16),
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(loc.cancel),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
            }
          },
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(loc.save),
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              _imageFile != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                  : Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 200,
                    ),
                  ),
              Positioned(
                top: 8,
                right: 8,
                child:
                    _imageFile != null
                        ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: loc.couponNameLabel),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.couponNameHint;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: loc.validDateLabel,
                border: OutlineInputBorder(),
              ),
              child: Text(
                _selectedDate != null
                    ? _selectedDate.toString().split(' ')[0]
                    : loc.validDateHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(labelText: loc.couponCodeLabel),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _memoController,
            decoration: InputDecoration(labelText: loc.memoLabel),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedFolder,
            items:
                ['카페', '편의점', '영화'].map((folder) {
                  return DropdownMenuItem(value: folder, child: Text(folder));
                }).toList(),
            onChanged: (value) => setState(() => _selectedFolder = value),
            decoration: InputDecoration(labelText: loc.folderLabel),
            validator: (value) => value == null ? loc.folderHint : null,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(loc.alarmLabel),
              Switch(
                value: _enableAlarm,
                onChanged: (value) {
                  setState(() {
                    _enableAlarm = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        _buildImagePicker(),
                        const SizedBox(height: 16),
                        _buildFormFields(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
