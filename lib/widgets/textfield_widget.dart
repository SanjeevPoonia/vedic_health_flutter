import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldShow extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldShow(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator != null ? validator : null,
          controller: controller != null ? controller : null,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}



class TextFieldRegister extends StatelessWidget {
  String labeltext;
  final String? Function(String?)? validator;
  var controller;

  TextFieldRegister(
      {required this.labeltext,
        this.validator,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator != null ? validator : null,
          controller: controller != null ? controller : null,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldPhone extends StatelessWidget {
  String labeltext;
  final String? Function(String?)? validator;
  var controller;

  TextFieldPhone(
      {required this.labeltext,
        this.validator,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator != null ? validator : null,
          controller: controller != null ? controller : null,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class TextFieldDisabled extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldDisabled(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          cursorHeight: 28,
          enabled: false,
          validator: validator != null ? validator : null,
          controller: controller != null ? controller : null,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldNumber extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldNumber(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mobile Number",
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              )),
          SizedBox(height: 5),
          TextFormField(
              cursorHeight: 22,
              validator: validator != null ? validator : null,
              controller: controller != null ? controller : null,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15.0,
                height: 1.6,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  isDense: true,

                  contentPadding: const EdgeInsets.fromLTRB(3.0, 0, 0.0, 0),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 30, minHeight: 28),
                  prefixText: "+91 ",
                  prefixStyle: TextStyle(
                    fontSize: 15.0,
                    height: 1.6,
                    color: Colors.black,
                  ),
                  errorMaxLines: 2)),
        ],
      ),
    );
  }
}

class TextFieldSeller22 extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;
  FocusNode focusNode;

  TextFieldSeller22(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.validator,
        this.controller,required this.focusNode});
  TextFieldSellerState createState()=>TextFieldSellerState();


}

class TextFieldSellerState extends State<TextFieldSeller22>
{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            cursorHeight: 22,
            focusNode: widget.focusNode,
            validator:widget. validator != null ? widget.validator : null,
            controller:widget. controller != null ?widget. controller : null,
            maxLength: 10,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
            ),
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(3.0, 0, 0.0, 0),
                prefixIconConstraints:
                BoxConstraints(minWidth: 30, minHeight: 28),
                prefixText: "+91 ",
              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ),
                prefixStyle: TextStyle(
                  fontSize: 15.0,
                  height: 1.6,
                  color: Colors.black,
                ),
                errorMaxLines: 2)),
      ],
    );
  }
}




class TextFieldAccountNumber extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldAccountNumber(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.validator,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TextFormField(
              cursorHeight: 18,
              validator: validator != null ? validator : null,
              controller: controller != null ? controller : null,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: 15.0,
                  height: 1.6,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
              ),

              decoration: InputDecoration(
                  isDense: true,
                  labelText: labeltext,
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(3.0, 0, 0.0, 0),
                  prefixIconConstraints:
                  BoxConstraints(minWidth: 30, minHeight: 28),
                  errorMaxLines: 2)),
        ],
      ),
    );
  }
}

class TextFieldNumber22 extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldNumber22(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.validator,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mobile Number",
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              )),
          SizedBox(height: 5),
          TextFormField(
              cursorHeight: 22,
              validator: validator != null ? validator : null,
              controller: controller != null ? controller : null,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 15.0,
                height: 1.6,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.fromLTRB(3.0, 0, 0.0, 0),
                  prefixIconConstraints:
                  BoxConstraints(minWidth: 30, minHeight: 28),
                  prefixText: "+91 ",
                  prefixStyle: TextStyle(
                    fontSize: 15.0,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  errorMaxLines: 2)),
        ],
      ),
    );
  }
}

class TextInputAddress extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextInputAddress(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            transform: Matrix4.translationValues(5.0, 15, 0.0),
            child: Text("Mobile Number",
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7),
                )),
          ),
          TextFormField(
              cursorHeight: 22,
              validator: validator != null ? validator : null,
              controller: controller != null ? controller : null,
              maxLength: 10,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: 15.0,
                  height: 1.6,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(3.0, 19, 0.0, 0),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 30, minHeight: 30),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5, top: 20, right: 2),
                      child: Text('+91',
                          style: const TextStyle(
                            fontSize: 15.0,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ))),
                  errorMaxLines: 2)),
        ],
      ),
    );
  }
}

class TextFieldShow2 extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  final String? Function(String?)? validator;

  TextFieldShow2(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: fieldIC,
              ),
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //  prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldAddress extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  bool? enabled;
  final String? Function(String?)? validator;

  TextFieldAddress(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
        this.enabled,
      this.validator});

  TextFieldState createState() => TextFieldState();
}

class TextFieldState extends State<TextFieldAddress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        enabled: widget.enabled!=null?widget.enabled:true,
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




class TextFieldAddressName extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  bool? enabled;
  final String? Function(String?)? validator;

  TextFieldAddressName(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller,
        this.enabled,
        this.validator});

  TextFieldNameState createState() => TextFieldNameState();
}

class TextFieldNameState extends State<TextFieldAddressName> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
          enabled: widget.enabled!=null?widget.enabled:true,
          maxLength: 30,
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




////////////

class TextFieldRating extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  bool? enabled;
  final String? Function(String?)? validator;

  TextFieldRating(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller,
        this.enabled,
        this.validator});

  TextFieldRatingState createState() => TextFieldRatingState();
}

class TextFieldRatingState extends State<TextFieldRating> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: widget.enabled!=null?widget.enabled:true,
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




class TextFieldGuestAddress extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  final String? Function(String?)? validator;

  TextFieldGuestAddress(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller,
        this.validator});

  TextFieldGuestAddressState createState() => TextFieldGuestAddressState();
}

class TextFieldGuestAddressState extends State<TextFieldGuestAddress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




class TextFieldTicket extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  final String? Function(String?)? validator;

  TextFieldTicket(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      this.validator});

  TextFieldTicketState createState() => TextFieldTicketState();
}

class TextFieldTicketState extends State<TextFieldTicket> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: false,
          maxLines: 3,
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 12.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10,bottom: 5),
              fillColor: Color(0xFFe2e2e2),
              filled: true,
              //prefixIcon: fieldIC,

              hintText: widget.labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldMobile extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  final String? Function(String?)? validator;

  TextFieldMobile(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      this.validator});

  TextFieldMobileState createState() => TextFieldMobileState();
}

class TextFieldMobileState extends State<TextFieldMobile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.controller,
          validator: widget.validator == null ? null : widget.validator,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              errorMaxLines: 2,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,
              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldProfile extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  bool enabled;
  final String? Function(String?)? validator;

  TextFieldProfile(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      required this.enabled,
      this.validator});

  TextFieldState22 createState() => TextFieldState22();
}

class TextFieldState22 extends State<TextFieldProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: widget.enabled,
          validator: widget.validator,
          controller: widget.controller,
          style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0),
              filled: true,
              fillColor:
                  widget.enabled ? Colors.white : Colors.grey.withOpacity(0.2),
              hintText: widget.labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




class TextFieldName extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  bool enabled;
  final String? Function(String?)? validator;

  TextFieldName(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller,
        required this.enabled,
        this.validator});

  TextFieldNameState22 createState() => TextFieldNameState22();
}

class TextFieldNameState22 extends State<TextFieldName> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: widget.enabled,
          validator: widget.validator,
          controller: widget.controller,
          maxLength: 30,
          style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0),
              filled: true,
              fillColor:
              widget.enabled ? Colors.white : Colors.grey.withOpacity(0.2),
              hintText: widget.labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}














class TextFieldProfileEmail extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  bool theme;
  Icon suffixIc;
  var controller;
  bool enabled;
  final String? Function(String?)? validator;

  TextFieldProfileEmail(
      {required this.labeltext,
        required this.fieldIC,
        required this.theme,
        required this.suffixIc,
        this.controller,
        required this.enabled,
        this.validator});

  TextFieldEmailState createState() => TextFieldEmailState();
}

class TextFieldEmailState extends State<TextFieldProfileEmail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4,right: 5,top: 4),
      child: TextFormField(
          enabled: false,
          validator: widget.validator,
          controller: widget.controller,
          style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              height: 1.6,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0),
              filled: true,
              fillColor:
              widget.theme ? Colors.white : Colors.grey.withOpacity(0.2),
              hintText: widget.labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}







class TextFieldPhone22 extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;
  var isEnabled;

  TextFieldPhone22(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      this.isEnabled});

  TextFieldPhoneState createState() => TextFieldPhoneState();
}

class TextFieldPhoneState extends State<TextFieldPhone22> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: widget.isEnabled == null ? true : widget.isEnabled,
          keyboardType: TextInputType.number,
          controller: widget.controller,
          style: const TextStyle(
              fontSize: 15.0,
              height: 1.6,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              filled: true,
              fillColor: widget.isEnabled
                  ? Colors.white
                  : Colors.grey.withOpacity(0.3),
              contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0),
              //prefixIcon: fieldIC,

              hintText: widget.labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;

  TextFieldWithIcon(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: false,
        controller: controller,
        style: const TextStyle(
          fontSize: 15.0,
          height: 1.6,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
            //prefixIcon: fieldIC,
            suffixIcon: Container(
              child: fieldIC,
            ),
            labelText: labeltext,
            labelStyle: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
            )));
  }
}


class TextFieldWithIconEmail extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;

  TextFieldWithIconEmail(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        enabled: false,
        style: const TextStyle(
          fontSize: 15.0,
          height: 1.6,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
            //prefixIcon: fieldIC,
            suffixIcon: Container(
              child: fieldIC,
            ),
            labelText: labeltext,
            labelStyle: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
            )));
  }
}


class TextFieldWidget extends StatelessWidget {
  String labeltext;
  Widget fieldIC;
  Icon suffixIc;
  var controller;
  var isEnabled;
  final String? Function(String?)? validator;

  TextFieldWidget(
      {required this.labeltext,
      required this.fieldIC,
      required this.suffixIc,
      this.controller,
      this.isEnabled,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: isEnabled == null ? true : isEnabled,
          validator: validator != null ? validator : null,
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
              /* suffixIcon: Container(
                child: fieldIC,
              ),*/
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}



class TextFieldWidgetUser extends StatelessWidget {
  String labeltext;
  Widget fieldIC;
  Icon suffixIc;
  var controller;
  var isEnabled;
  final String? Function(String?)? validator;

  TextFieldWidgetUser(
      {required this.labeltext,
        required this.fieldIC,
        required this.suffixIc,
        this.controller,
        this.isEnabled,
        this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: isEnabled == null ? true : isEnabled,
          validator: validator != null ? validator : null,
          controller: controller,
          inputFormatters:[
            LengthLimitingTextInputFormatter(30),
          ],
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
              /* suffixIcon: Container(
                child: fieldIC,
              ),*/
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}


class TextFieldSeller extends StatelessWidget {
  String labeltext;
  var controller;
  var isEnabled;
  final String? Function(String?)? validator;

  TextFieldSeller(
      {required this.labeltext,
      this.controller,
      this.isEnabled,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          enabled: isEnabled == null ? true : isEnabled,
          validator: validator != null ? validator : null,
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}


class TextFieldSellerName extends StatelessWidget {
  String labeltext;
  var controller;
  var isEnabled;
  final String? Function(String?)? validator;

  TextFieldSellerName(
      {required this.labeltext,
        this.controller,
        this.isEnabled,
        this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
          enabled: isEnabled == null ? true : isEnabled,
          validator: validator != null ? validator : null,
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}



class TextFieldSellerContact extends StatelessWidget {
  String labeltext;
  var controller;
  var isEnabled;
  final String? Function(String?)? validator;

  TextFieldSellerContact(
      {required this.labeltext,
        this.controller,
        this.isEnabled,
        this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: TextFormField(
          inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
          enabled: isEnabled == null ? true : isEnabled,
          validator: validator != null ? validator : null,
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class CustomTextFieldWidget extends StatelessWidget {
  String labeltext;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  CustomTextFieldWidget(
      {required this.labeltext,
      required this.suffixIc,
      this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: Row(
                children: [
                  Text(labeltext),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class CustomTextFieldWidget2 extends StatelessWidget {
  String labeltext;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  CustomTextFieldWidget2(
      {required this.labeltext,
        required this.suffixIc,
        this.controller,
        this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: Row(
                children: [
                  Text(labeltext),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class PhoneTextFieldWidget extends StatelessWidget {
  String labeltext;
  final String? Function(String?)? validator;
  var controller;

  PhoneTextFieldWidget(
      {required this.labeltext, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            height: 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              errorMaxLines: 2,
              label: Row(
                children: [
                  Text(labeltext),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class PinTextFieldWidget extends StatelessWidget {
  String labeltext;

  PinTextFieldWidget({required this.labeltext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            height: 1.6,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
