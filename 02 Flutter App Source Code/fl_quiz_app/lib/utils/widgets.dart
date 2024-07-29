import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'constant.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final String? navigate;
  const PrimaryButton({Key? key, required this.text, this.onTap, this.navigate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate != null
          ? () => Navigator.pushNamed(context, '/$navigate')
          : onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: borderRadius10,
          boxShadow: [primaryButtonShadow6],
        ),
        child: Center(child: Text(text, style: whiteBold18)),
      ),
    );
  }
}

class PrimaryTextField extends StatelessWidget {
  final bool? enabled;
  final TextEditingController? controller;
  final SizedBox? spaceBW;
  final int? maxLines;
  final String? header;
  final TextStyle? headerStyle;
  final String? hintText;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  const PrimaryTextField(
      {Key? key,
      this.header,
      this.hintText,
      this.prefixIcon,
      this.textInputAction,
      this.keyboardType,
      this.headerStyle,
      this.maxLines,
      this.spaceBW,
      this.controller,
      this.enabled,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header != null
            ? Text(header!, style: headerStyle ?? blackSemiBold16)
            : const SizedBox(),
        header != null ? spaceBW ?? heightSpace5 : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2.5),
          decoration: BoxDecoration(
            borderRadius: borderRadius10,
            boxShadow: [color00Shadow],
            color: white,
          ),
          child: Row(children: [
            prefixIcon != null
                ? Image.asset(
                    prefixIcon!,
                    height: 2.h,
                  )
                : const SizedBox(),
            prefixIcon != null ? widthSpace10 : const SizedBox(),
            Expanded(
                child: TextField(
              enabled: enabled ?? true,
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              textInputAction: textInputAction ?? TextInputAction.next,
              cursorColor: primaryColor,
              style: color94SemiBold15,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: color94SemiBold16),
            )),
            suffixIcon != null ? suffixIcon! : const SizedBox(),
          ]),
        )
      ],
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Color? color;
  final Alignment? alignment;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final VoidCallback? onTap;
  const PrimaryContainer(
      {Key? key,
      this.height,
      this.width,
      this.padding,
      this.margin,
      this.child,
      this.onTap,
      this.borderRadius,
      this.border,
      this.boxShadow,
      this.alignment,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment ?? Alignment.center,
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? white,
          border: border,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          boxShadow: boxShadow ?? [color00Shadow],
        ),
        child: child,
      ),
    );
  }
}

class PushNavigate extends StatelessWidget {
  final String navigate;
  final Widget child;
  const PushNavigate({Key? key, required this.child, required this.navigate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/$navigate'),
      child: child,
    );
  }
}

class PrimaryAppBar extends StatelessWidget {
  final String title;
  final bool withBackArrow;
  const PrimaryAppBar(
      {Key? key, required this.title, this.withBackArrow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        height: SizerUtil.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(homeBubbleBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              withBackArrow
                  ? IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: white,
                      ))
                  : widthSpace20,
              Text(title, style: whiteBold20)
            ],
          ),
        ),
      ),
    );
  }
}
