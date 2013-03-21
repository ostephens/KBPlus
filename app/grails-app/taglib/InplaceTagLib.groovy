import com.k_int.kbplus.*

class InplaceTagLib {

  def refdataValue = { attrs, body ->
    log.debug("refdataValue ${attrs}");
    if ( attrs.cat ) {
      def category = RefdataCategory.findByDesc(attrs.cat)
      if ( category ) {
        def value = RefdataValue.findByOwnerAndValue(category, attrs.val)

        def id = "${attrs.domain}:${attrs.pk}:${attrs.field}:${attrs.cat}:${attrs.id}"
        if ( value ) {
          //  out << "<span class=\"select-icon ${value?.icon}\">&nbsp;</span><span id=\"${id}\" class=\"${attrs.class}\">"
          out << "<span id=\"${id}\" class=\"${attrs.class}\">"
          if ( value?.icon ) {
            out << "<span class=\"select-icon ${value?.icon}\">&nbsp;</span>"
          }
          out << "<span>"
          out << attrs.val
          out << "</span>"
        }
        else {
          out << "<span id=\"${id}\" class=\"${attrs.class}\"></span>"
        }
      }
      else {
        out << "Unknown refdata category ${attrs.cat}"
      }
    }
    else {
      out << "No category for refdata"
    }
    
  }

  def singleValueFieldNote= { attrs, body ->
    out << "<p class=\"${attrs.class}\" id=\"__fieldNote_${attrs.domain}\">"
    if ( attrs.value ) {
      out << attrs.value?.owner?.content
    }
    out << "</p>"
  }

  def inPlaceEdit = { attrs, body ->
    def data_link = createLink(controller:'ajax', action: 'editableSetValue')
    out << "<span id=\"${attrs.domain}:${attrs.pk}:${attrs.field}:${attrs.id}\" class=\"xEditableValue ${attrs.class?:''}\" data-type=\"textarea\" data-pk=\"${attrs.domain}:${attrs.pk}\" data-name=\"${attrs.pk}\" data-url=\"${data_link}\">'"
    if ( body ) {
      out << body()
    }
    out << "</span>"
  }

  def relation = { attrs, body ->
    out << "<span class=\"${attrs.class}\" id=\"${attrs.domain}:${attrs.pk}:${attrs.field}:${attrs.id}\">"
    if ( body ) {
      out << body()
    }
    out << "</span>"
  }

  def relationAutocomplete = { attrs, body ->
  }
}
