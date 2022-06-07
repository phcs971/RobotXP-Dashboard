// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robotxp_dashboard/app/models/filter_model.dart';
import 'package:robotxp_dashboard/app/utils.dart';

import '../stores/home_store.dart';

class RenameDialog extends StatefulWidget {
  const RenameDialog({Key? key}) : super(key: key);

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final store = GetIt.I<HomeStore>();
  String value = "";
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black),
    );
    return AlertDialog(
      title: const Text("Renomear Trajetória"),
      content: TextField(
        onChanged: (v) => value = v,
        decoration: InputDecoration(
          hintText: "Nome da Trajetória",
          border: border,
          errorBorder: border,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          focusedErrorBorder: border,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "CANCELAR",
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (value.isEmpty) return;
            (store.filter as TrajectoryFilterModel?)?.trajectory.name = value;
            await store.putTrajectoryName(value);
            Navigator.of(context).pop(true);
          },
          child: const Text(
            "CONFIRMAR",
            style: TextStyle(color: RobotColors.primary),
          ),
        ),
      ],
    );
  }
}
