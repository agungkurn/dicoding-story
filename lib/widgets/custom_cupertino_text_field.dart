import 'package:flutter/cupertino.dart';

class CustomCupertinoTextField extends StatefulWidget {
  final String? errorText;
  final TextEditingController? controller;
  final String? placeholder;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final TextCapitalization textCapitalization;
  final void Function(String)? onChanged;

  const CustomCupertinoTextField({
    super.key,
    this.controller,
    this.errorText,
    this.placeholder,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefix,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<CustomCupertinoTextField> createState() =>
      _CustomCupertinoTextFieldState();
}

class _CustomCupertinoTextFieldState extends State<CustomCupertinoTextField> {
  late bool _obscure;
  late final TextEditingController _internalController;
  bool _usingInternalController = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;

    if (widget.controller == null) {
      _internalController = TextEditingController();
      _usingInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_usingInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoTextField(
          controller: widget.controller ?? _internalController,
          placeholder: widget.placeholder,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          enabled: widget.enabled,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.obscureText ? 1 : widget.minLines,
          onChanged: widget.onChanged,
          prefix: widget.prefix,
          textCapitalization: widget.textCapitalization,
          suffix:
              widget.obscureText
                  ? Container(
                    margin: EdgeInsets.only(right: 8),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: _toggleVisibility,
                      child: Icon(
                        _obscure
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        size: 20,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  )
                  : null,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasError
                      ? CupertinoColors.systemRed
                      : CupertinoColors.separator,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: AnimatedOpacity(
            opacity: hasError ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child:
                hasError
                    ? Text(
                      widget.errorText!,
                      style: const TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 12,
                      ),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
