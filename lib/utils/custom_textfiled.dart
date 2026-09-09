
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/formz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin DecoratedBorder on Widget {
  OutlineInputBorder buildBorder({
    Color? color,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: color != null
          ? BorderSide(
              color: color,
              width: width,
            )
          : const BorderSide(),
    );
  }
}

class DecoratedTextField extends StatefulWidget with DecoratedBorder {
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? currentValue;
  final String? hintText;
  final String? helperText;
  final int? minLines;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final ValidationError? validationError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function()? onTap;
  final String? aboveText;
  final bool obscureText;

  const DecoratedTextField({
    Key? key,
    this.inputType,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.currentValue,
    this.validationError,
    this.onChanged,
    this.onFieldSubmitted,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.helperText,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.aboveText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<DecoratedTextField> createState() =>
      _DecoratedTextFieldState();
}

class _DecoratedTextFieldState
    extends State<DecoratedTextField> {
  bool get isPasswordField =>
      widget.inputType == TextInputType.visiblePassword;

  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _obscureText =
        widget.obscureText || isPasswordField;
  }

  void _fieldFocusChange({
    required BuildContext context,
    required FocusNode focusNode,
    required FocusNode nextFocusNode,
  }) {
    focusNode.unfocus();

    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    // COLORS
    
    // Theme-based color.
    // Automatically changes according to Light/Dark Theme.
    final Color textColor = context.onSurface;

    // Your custom fixed app colors.
    final Color labelColor = context.primaryBlue;

    final Color hintColor =
        context.hintColor.withOpacity(0.6);

    final Color borderColor =
        context.lightBlue;

    final Color activeBorderColor =
        context.primaryBlue;

    final Color iconColor =
        context.primaryBlue;

        // UI
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        
        // ABOVE TEXT / LABEL
        

        if (widget.aboveText != null) ...[
          Text(
            widget.aboveText!,
            style: context.labelMR.copyWith(
              color: labelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),
        ],

        
        // TEXT FIELD
        

        TextFormField(
          initialValue: widget.currentValue,

          controller: widget.controller,

          focusNode: widget.focusNode,

          onTap: widget.onTap,

          
          // FIELD SUBMITTED
          

          onFieldSubmitted: (value) {
            if (widget.nextFocusNode != null &&
                widget.focusNode != null) {
              _fieldFocusChange(
                context: context,
                focusNode: widget.focusNode!,
                nextFocusNode: widget.nextFocusNode!,
              );
            }

            widget.onFieldSubmitted?.call(value);
          },

          
          // INPUT
          

          keyboardType: widget.inputType,

          textCapitalization:
              widget.textCapitalization,

          obscureText: isPasswordField
              ? _obscureText
              : widget.obscureText,

          onChanged: widget.onChanged,

          maxLines: widget.maxLines,

          minLines: widget.minLines,

          textInputAction:
              widget.nextFocusNode != null
                  ? TextInputAction.next
                  : widget.textInputAction,

          enabled: widget.enabled,

          
          // TEXT STYLE
          

          style: context.labelMR.copyWith(
            color: textColor,
            fontSize: 14,
          ),

          
          // INPUT DECORATION
          

          decoration: InputDecoration(
            hintText: widget.hintText,

            helperText: widget.helperText,

            enabled: widget.enabled,

            errorMaxLines: 2,

            errorText:
                widget.validationError?.errorText,

            
            // PREFIX ICON
            

            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: iconColor,
                        size: 20,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  )
                : null,

            
            // SUFFIX ICON
            

            suffixIcon: isPasswordField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText;
                      });
                    },

                    icon: Icon(
                      _obscureText
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,

                      color: iconColor,

                      size: 20,
                    ),
                  )
                : widget.suffixIcon,

            
            // PADDING
            

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),

            
            // LABEL
            

            floatingLabelBehavior:
                FloatingLabelBehavior.never,

            
            // DEFAULT BORDER
            

            border: widget.buildBorder(
              color: borderColor,
            ),

            
            // ENABLED BORDER
            

            enabledBorder:
                widget.validationError ==
                        ValidationError.empty
                    ? widget.buildBorder(
                        color: context.error,
                        width: 1.5,
                      )
                    : (widget.currentValue != null &&
                            widget.currentValue!.isNotEmpty)
                        ? widget.buildBorder(
                            color: activeBorderColor,
                            width: 1.5,
                          )
                        : widget.buildBorder(
                            color: borderColor,
                          ),

            
            // FOCUSED BORDER
            

            focusedBorder: widget.buildBorder(
              color: activeBorderColor,
              width: 2,
            ),

            
            // ERROR BORDER
            

            errorBorder: widget.buildBorder(
              color: context.error,
              width: 1.5,
            ),

            
            // DISABLED BORDER
            

            disabledBorder: widget.buildBorder(
              color: borderColor.withOpacity(0.4),
              width: 1,
            ),

            
            // HINT STYLE
            

            hintStyle: context.labelSR.copyWith(
              color: hintColor,
              fontSize: 14,
            ),

            
            // HELPER STYLE
            

            helperStyle: context.labelSR.copyWith(
              color: labelColor,
            ),

            
            // ERROR STYLE
            

            errorStyle: context.labelSR.copyWith(
              color: context.error,
            ),
          ),
        ),
      ],
    );
  }
}
