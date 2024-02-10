import 'package:user/consts/consts.dart';

customDropDownButton(
    {selectedValue, onchange, required List<String> list, hint, label}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      "$label".text.make(),
      10.heightBox,
      DropdownButtonFormField<String>(
              hint:
                  hint == null ? null : "$hint".text.color(borderColor).make(),
              icon: Icon(Icons.expand_more),
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              value: selectedValue,
              items: list.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: "$value".text.make().paddingSymmetric(horizontal: 5),
                  );
                },
              ).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                return null;
              },
              onChanged: onchange)
          .box
          .make(),
    ],
  ).marginOnly(top: 10);
}
