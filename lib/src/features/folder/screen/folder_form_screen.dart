import 'package:coupon_place/src/shared/utils/icon_mapping.dart';
import 'package:coupon_place/src/shared/widgets/box_container.dart';
import 'package:coupon_place/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FolderFormScreen extends StatefulWidget {
  final String? initialName;
  final Color? initialColor;
  final IconData? initialIcon;
  final void Function(String name, Color color, IconData icon) onSubmit;

  const FolderFormScreen({
    super.key,
    this.initialName,
    this.initialColor,
    this.initialIcon,
    required this.onSubmit,
  });

  @override
  State<FolderFormScreen> createState() => _FolderFormScreenState();
}

class _FolderFormScreenState extends State<FolderFormScreen> {
  late TextEditingController _controller;
  late Color _selectedColor;
  late IconData _selectedIcon;
  final _formKey = GlobalKey<FormState>();

  final List<Color> _colorOptions = List.generate(
    15,
    (i) => Colors.primaries[i % Colors.primaries.length],
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _selectedColor = widget.initialColor ?? Colors.deepPurple;
    _selectedIcon = widget.initialIcon ?? Icons.list;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_controller.text.trim(), _selectedColor, _selectedIcon);
      Navigator.pop(context);
    }
  }

  Widget _previewAndFolderName(BuildContext context) {
    return BoxContainer(
      child: Column(
        children: [
          _preview(context),
          const SizedBox(height: 10),
          _folderName(context),
        ],
      ),
    );
  }

  Widget _preview(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: _selectedColor,
      child: Icon(_selectedIcon, size: 60, color: Colors.white),
    );
  }

  Widget _folderName(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return loc.folderNameEmptyError;
        }
        return null;
      },
      controller: _controller,
      decoration: InputDecoration(
        hintText: loc.folderNameHint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _colorChooser(BuildContext context) {
    return BoxContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const int itemsPerRow = 6;
          final double spacing = 8;
          final double totalSpacing = spacing * (itemsPerRow - 1);
          final double itemWidth =
              (constraints.maxWidth - totalSpacing) / itemsPerRow;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children:
                _colorOptions.map((color) {
                  return SizedBox(
                    width: itemWidth,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: CircleAvatar(
                        radius: itemWidth / 2,
                        backgroundColor: color,
                        child:
                            _selectedColor == color
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                                : null,
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }

  Widget _iconChooser(BuildContext context) {
    return BoxContainer(
      child: SizedBox(
        height: 200,
        child: SingleChildScrollView(
          child: GridView.count(
            crossAxisCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:
                iconOptions.map((icon) {
                  return IconButton(
                    onPressed: () => setState(() => _selectedIcon = icon),
                    icon: Icon(
                      icon,
                      color:
                          _selectedIcon == icon ? _selectedColor : Colors.grey,
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.initialName ?? loc.folderAdd),
        centerTitle: true,
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
            onPressed: _submit,
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(loc.save),
          ),
        ],
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _previewAndFolderName(context),
              const SizedBox(height: 16),
              _colorChooser(context),
              const SizedBox(height: 16),
              _iconChooser(context),
            ],
          ),
        ),
      ),
    );
  }
}
