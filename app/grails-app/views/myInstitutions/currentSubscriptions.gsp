<!doctype html>
<r:require module="annotations" />

<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>KB+ ${institution.name} - Current Subscriptions</title>
  </head>
  <body>

    <div class="container">
      <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <li> <g:link controller="myInstitutions" action="currentSubscriptions" params="${[shortcode:params.shortcode]}">${institution.name} Current Subscriptions</g:link> </li>
          <g:if test="${editable}">
              <li class="pull-right"><span class="badge badge-warning">Editable</span>&nbsp;</li>
          </g:if>
      </ul>
    </div>

   <g:if test="${flash.message}">
      <div class="container">
        <bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert>
      </div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container">
        <bootstrap:alert class="error-info">${flash.error}</bootstrap:alert>
      </div>
    </g:if>

    <div class="container">

      <h1>${institution?.name} - Current Subscriptions</h1>

      <g:render template="subsNav" contextPath="." />
    </div>

    <div class="container">
      <div class="well">
      <g:form action="currentSubscriptions" params="${[shortcode:params.shortcode]}" controller="myInstitutions" method="get" class="form-inline">



        <label class="control-label">Search text: </label> 
        <input type="text" name="q" placeholder="enter search term..." value="${params.q?.encodeAsHTML()}"/>
            
        <label class="control-label">Valid On: </label>
        <div class="input-append date">
          <input class="span2 datepicker-class" size="16" type="text"name="validOn" value="${validOn}">
        </div>

        <label class="control-label">Date: </label>
        <g:select name="dateBeforeFilter"  style="width: 125px" value="${params.dateBeforeFilter}" from="${['-None-','Renewal Date','End Date']}"/>
         before
           <div class="input-append date">
              <input class="span2 datepicker-class" size="16" type="text"name="dateBeforeVal" value="${params.dateBeforeVal}">
          </div>
        <input type="submit" class="btn btn-primary" value="Search" />
      </g:form>
      </div>
    </div>


      <div class="container subscription-results">
        <table class="table table-striped table-bordered table-condensed table-tworow">
          <tr>
            <g:sortableColumn colspan="7" params="${params}" property="s.name" title="${message(code:'licence.slash.name')}" />
            <th rowspan="2">Action</th>
          </tr>

          <tr>
            <th><g:annotatedLabel owner="${institution}" property="linkedPackages">Linked Packages</g:annotatedLabel></th>
            <th>Consortia</th>
            <g:sortableColumn params="${params}" property="s.startDate" title="Start Date" />
            <g:sortableColumn params="${params}" property="s.endDate" title="End Date" />
            <g:sortableColumn params="${params}" property="s.manualRenewalDate" title="Renewal Date" />
            <th>Platform</th>
          </tr>
          <g:each in="${subscriptions}" var="s">
            <tr>
              <td colspan="7">
                <g:link controller="subscriptionDetails" action="index" params="${[shortcode:params.shortcode]}" id="${s.id}">
                  <g:if test="${s.name}">${s.name}</g:if><g:else>-- Name Not Set  --</g:else>
                  <g:if test="${s.consortia}">( ${s.consortia?.name} )</g:if>
                </g:link>
                <g:if test="${s.owner}"> 
                  <span class="pull-right">${message(code:'licence')} : <g:link controller="licenseDetails" action="index" id="${s.owner.id}">${s.owner?.reference}</g:link></span>
                </g:if>
              </td>
              <td rowspan="2">
                <g:if test="${editable}">
                    <g:link controller="myInstitutions" action="actionCurrentSubscriptions" params="${[shortcode:params.shortcode,basesubscription:s.id]}" onclick="return confirm('Are you sure you want to delete ${s.name?:'this subscription'}?')"class="btn btn-danger">Delete</g:link>
                </g:if>
              </td>
            </tr>
            <tr>
              <td><ul>
                <g:each in="${s.packages}" var="sp">
                  <li>
                    <g:link controller="packageDetails" action="show" id="${sp.pkg?.id}" title="${sp.pkg?.contentProvider?.name}">${sp.pkg.name}</g:link>
                  </li>
                </g:each></ul>
                <g:if test="${((s.packages==null) || (s.packages.size()==0))}">
                  <i>None currently, Add packages via <g:link controller="subscriptionDetails" action="linkPackage" id="${s.id}">Link Package</g:link></i>
                </g:if>
                &nbsp;<br/>
                &nbsp;<br/>
              </td>
              <td>${s.getConsortia()?.name}</td>
              <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${s.startDate}"/></td>
              <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${s.endDate}"/></td>
              <td><g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${s.renewalDate}"/></td>
              <td>
                <g:each in="${s.instanceOf?.packages}" var="sp">
                  ${sp.pkg?.nominalPlatform?.name}<br/>
                </g:each>
              </td>
            </tr>
          </g:each>
        </table>
      </div>

  
      <div class="pagination" style="text-align:center">
        <g:if test="${subscriptions}" >
          <bootstrap:paginate  action="currentSubscriptions" controller="myInstitutions" params="${params}" next="Next" prev="Prev" max="${max}" total="${num_sub_rows}" />
        </g:if>
      </div>

    <r:script type="text/javascript">

        $(".datepicker-class").datepicker({
            format:"${session.sessionPreferences?.globalDatepickerFormat}"
        });
    </r:script>

  </body>
</html>
