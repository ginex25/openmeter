import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/tags/model/tag_dto.dart';
import 'package:openmeter/features/tags/provider/tag_list_provider.dart';
import 'package:openmeter/shared/utils/color_adjuster.dart';
import 'package:uuid/uuid.dart';

class AddTagButton extends StatelessWidget {
  const AddTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return AddTagContent();
          },
        );
      },
      icon: const Icon(Icons.add),
      tooltip: 'Tag erstellen',
    );
  }
}

class AddTagContent extends ConsumerStatefulWidget {
  const AddTagContent({super.key});

  @override
  ConsumerState createState() => _AddTagsContentState();
}

class _AddTagsContentState extends ConsumerState<AddTagContent> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _pickedIndex = 0;

  final List<Color> _listColors = const [
    Color(0xff344C11),
    Color(0xff828D00),
    Color(0xffAEC670),
    Color(0xff37745B),
    Color(0xff217074),
    Color(0xff2F70AF),
    Color(0xff00457E),
    Color(0xff02315E),
    Color(0xffD7A3B6),
    Color(0xff806491),
    Color(0xff54387F),
    Color(0xffFAAB01),
    Color(0xffE48716),
    Color(0xffF5704A),
    Color(0xffA9612B),
    Color(0xff432D2D),
    Color(0xffF46060),
    Color(0xffBC0000),
  ];

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Neuer Tag',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte gebe einen Namen ein!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      icon: Icon(Icons.note), label: Text('Name')),
                ),
                const Text(
                  'Farbe wählen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                  ),
                  shrinkWrap: true,
                  itemCount: _listColors.length,
                  itemBuilder: (context, index) {
                    Widget child = Container();

                    if (index == _pickedIndex) {
                      child = const Icon(
                        Icons.check,
                        color: Colors.white,
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _pickedIndex = index);
                        },
                        child: CircleAvatar(
                          backgroundColor: _listColors[index],
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _saveTag();
                    },
                    label: const Text('Speichern'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveTag() async {
    if (_formKey.currentState!.validate()) {
      final int pickedColor = _listColors[_pickedIndex].toInt();

      final TagDto tag = TagDto(
        color: pickedColor,
        name: _nameController.text,
        uuid: const Uuid().v1(),
      );

      await ref.read(tagListProvider.notifier).addTag(tag).then(
        (value) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    }
  }
}
