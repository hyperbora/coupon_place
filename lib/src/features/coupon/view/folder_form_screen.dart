import 'package:coupon_place/src/common/widgets/box_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final List<IconData> _iconOptions = [
    Icons.list,
    Icons.star,
    Icons.coffee,
    Icons.shopping_cart,
    Icons.movie,
    Icons.fastfood,
    Icons.card_giftcard,
    Icons.local_offer,
    Icons.pets,
    Icons.sports_esports,
    Icons.bookmark,
    Icons.favorite,
    Icons.directions_car,
    Icons.home,
    Icons.school,
    Icons.flight,
    Icons.music_note,
    Icons.restaurant,
    Icons.local_cafe,
    Icons.local_florist,
    Icons.local_mall,
    Icons.local_play,
    Icons.local_pizza,
    Icons.local_taxi,
    Icons.beach_access,
    Icons.cake,
    Icons.child_friendly,
    Icons.directions_bike,
    Icons.directions_bus,
    Icons.directions_run,
    Icons.directions_walk,
    Icons.emoji_emotions,
    Icons.emoji_food_beverage,
    Icons.emoji_nature,
    Icons.emoji_objects,
    Icons.emoji_transportation,
  ];

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
                _iconOptions.map((icon) {
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
        title: Text(
          widget.initialName == null ? loc.folderAdd : loc.folderEdit,
        ),
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
