import 'package:flutter/material.dart';

Icon getIcon(icon){
  return Icon(icon,color: Colors.white,size: 25,);
}

TextStyle getStyle(fontsize,color,fontfamily,fontweight){
  return TextStyle(fontSize: fontsize,color:color,fontFamily: fontfamily,fontWeight: fontweight);
}