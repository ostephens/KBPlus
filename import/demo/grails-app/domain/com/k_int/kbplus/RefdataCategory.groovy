package com.k_int.kbplus

class RefdataCategory {

  String desc

  static mapping = {
         id column:'rdc_id'
    version column:'rdc_version'
       desc column:'rdc_description', index:'rdc_description_idx'
  }

  static constraints = {
  }
}
