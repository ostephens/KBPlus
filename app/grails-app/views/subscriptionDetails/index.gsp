<%@ page import="com.k_int.kbplus.Subscription" %>
<r:require module="annotations" />

<!doctype html>
<html>
  <head>
    <meta name="layout" content="mmbootstrap"/>
    <title>KB+ Subscription</title>

  </head>
  <body>

    <div class="container">
      <ul class="breadcrumb">
        <li> <g:link controller="home" action="index">Home</g:link> <span class="divider">/</span> </li>
        <g:if test="${subscriptionInstance.subscriber}">
          <li> <g:link controller="myInstitutions" action="currentSubscriptions" params="${[shortcode:subscriptionInstance.subscriber.shortcode]}"> ${subscriptionInstance.subscriber.name} Current Subscriptions</g:link> <span class="divider">/</span> </li>
        </g:if>
        <li> <g:link controller="subscriptionDetails" action="index" id="${subscriptionInstance.id}">Subscription ${subscriptionInstance.id} Details</g:link> </li>
        
        <li class="dropdown pull-right">
          <a class="dropdown-toggle btn btn-mini btn-primary" id="export-menu" role="button" data-toggle="dropdown" data-target="#" href="">Exports<b class="caret"></b></a>
          <ul class="dropdown-menu filtering-dropdown-menu" role="menu" aria-labelledby="export-menu">
           
            <li><g:link controller="subscriptionDetails" action="index" id="${subscriptionInstance.id}" params="${params + [format:'json']}">JSON</g:link></li>
            <li><g:link controller="subscriptionDetails" action="index" id="${subscriptionInstance.id}" params="${params + [format:'xml']}">XML</g:link></li>
            <g:each in="${transforms}" var="transkey,transval">
              <li><g:link action="index" id="${params.id}" params="${[format:'xml',transformId:transkey,mode: params.mode]}">${transval.name}</g:link></li>
            </g:each>
        </ul>

        <li class="pull-right">
          View:
          <div class="btn-group" data-toggle="buttons-radio">
            <g:link controller="subscriptionDetails" action="index" params="${params+['mode':'basic']}" class="btn btn-primary btn-mini ${((params.mode=='basic')||(params.mode==null))?'active':''}">Basic</g:link>
            <g:link controller="subscriptionDetails" action="index" params="${params+['mode':'advanced']}" button type="button" class="btn btn-primary btn-mini ${params.mode=='advanced'?'active':''}">Advanced</g:link>
          </div>
          &nbsp;
        </li>

    </li>
        <g:if test="${editable}">
          <li class="pull-right"><span class="badge badge-warning">Editable</span>&nbsp;</li>
        </g:if>
        <li class="pull-right"><g:annotatedLabel owner="${subscriptionInstance}" property="detailsPageInfo"></g:annotatedLabel>&nbsp;</li>
      </ul>
    </div>

    <g:if test="${flash.message}">
      <div class="container"><bootstrap:alert class="alert-info">${flash.message}</bootstrap:alert></div>
    </g:if>

    <g:if test="${flash.error}">
      <div class="container"><bootstrap:alert class="alert-error">${flash.error}</bootstrap:alert></div>
    </g:if>

    <div class="container">
      <g:if test="${params.asAt}"><h1>Snapshot on ${params.asAt} from </h1></g:if>
       <h1><g:xEditable owner="${subscriptionInstance}" field="name" /></h1>
       <g:render template="nav"  />
    </div>


    <g:render template="/templates/pendingChanges" model="${['pendingChanges': pendingChanges,'flash':flash,'model':subscriptionInstance]}"/>

   <div class="container">
      <dl>
        <dt>
          <g:annotatedLabel owner="${subscriptionInstance}" property="entitlements">
            <g:if test="${entitlements?.size() > 0}">
              Entitlements ( ${offset+1} to ${offset+(entitlements?.size())} of ${num_sub_rows}. 
                <g:if test="${params.mode=='advanced'}">Includes Expected or Expired entitlements, switch to <g:link controller="subscriptionDetails" action="index" params="${params+['mode':'basic']}">Basic</g:link> view to hide</g:if>
                <g:else>Expected or Expired entitlements are filtered, use <g:link controller="subscriptionDetails" action="index" params="${params+['mode':'advanced']}" button type="button" >Advanced</g:link> view to see them</g:else>
              )
            </g:if>
            <g:else>
              No entitlements yet
            </g:else>
          </g:annotatedLabel>
          <g:form action="index" params="${params}" method="get" class="form-inline">
             <input type="hidden" name="sort" value="${params.sort}">
             <input type="hidden" name="order" value="${params.order}">

             <label><g:annotatedLabel owner="${subscriptionInstance}" property="qryFilter"> Filter: </g:annotatedLabel></label>
             <input name="filter" value="${params.filter}"/>
             <label>From Package:</label> <select name="pkgfilter">
                                <option value="">All</option>
                               <g:each in="${subscriptionInstance.packages}" var="sp">
                                 <option value="${sp.pkg.id}" ${sp.pkg.id.toString()==params.pkgfilter?'selected=true':''}>${sp.pkg.name}</option>
                               </g:each>
                            </select>
           <g:if test="${params.mode!='advanced'}">
              <label>Entitlements as at:</label>
              <g:simpleHiddenValue id="asAt" name="asAt" type="date" value="${params.asAt}"/>
            </g:if>
             <input type="submit" class="btn btn-primary" />
          </g:form>
        </dt>
        <dd>
          <g:form action="subscriptionBatchUpdate" params="${[id:subscriptionInstance?.id]}" class="form-inline">
          <g:set var="counter" value="${offset+1}" />
          <g:hiddenField name="sort" value="${params.sort}"/>
          <g:hiddenField name="order" value="${params.order}"/>
          <g:hiddenField name="offset" value="${params.offset}"/>
          <g:hiddenField name="max" value="${params.max}"/>
          <table  class="table table-striped table-bordered">
            <thead>

            <tr>
              <th rowspan="2"></th>
              <th rowspan="2">#</th>
              <g:sortableColumn params="${params}" property="tipp.title.sortTitle" title="Title" />
              <th rowspan="2">Entitlement Medium (P/E)</th>
              <g:sortableColumn params="${params}" property="startDate" title="Earliest date" />
              <g:sortableColumn params="${params}" property="core_status" title="Core Status" />
              <th rowspan="2">Actions</th>
            </tr>  

            <tr>
              <th>Access Dates</th>
              <g:sortableColumn params="${params}" property="endDate" title="Latest Date" />
              <th> Core Medium </th>
            </tr>

            <tr class="no-background">  
              <g:if test="${editable}">
              

              <th>
                <input type="checkbox" name="chkall" onClick="javascript:selectAll();"/>
              </th>

              <th colspan="2">
                
                  <select id="bulkOperationSelect" name="bulkOperation">
                    <option value="edit">Edit Selected</option>
                    <option value="remove">Remove Selected</option>
                  </select>

                  <input type="Submit" value="Apply Batch Changes" onClick="return confirmSubmit()" class="btn btn-primary"/>
              </th>

              <th>
                  <g:simpleHiddenRefdata id="bulk_medium" name="bulk_medium" refdataCategory="IEMedium"/>
              </th>

              <th> <g:simpleHiddenValue id="bulk_start_date" name="bulk_start_date" type="date"/>  <br/>
                   <g:simpleHiddenValue id="bulk_end_date" name="bulk_end_date" type="date"/> 
              </th>
              <th>
                <g:simpleHiddenRefdata id="bulk_coreStatus" name="bulk_coreStatus" refdataCategory="CoreStatus"/> <br/>
              </th>
              </g:if>
               <g:else>
               <th colspan="7">  </th>
              </g:else>
              <th></th>
            </tr>
         </thead>
         <tbody>

          <g:if test="${entitlements}">
            <g:each in="${entitlements}" var="ie">
              <tr>
                <td><g:if test="${editable}"><input type="checkbox" name="_bulkflag.${ie.id}" class="bulkcheck"/></g:if></td>
                <td>${counter++}</td>
                <td>
                  <g:link controller="issueEntitlement" id="${ie.id}" action="show"><strong>${ie.tipp.title.title}</strong></g:link>

                  <g:if test="${ie.tipp?.hostPlatformURL}">( <a href="${ie.tipp?.hostPlatformURL}" TITLE="${ie.tipp?.hostPlatformURL}">Host Link</a> 
                            <a href="${ie.tipp?.hostPlatformURL}" TITLE="${ie.tipp?.hostPlatformURL} (In new window)" target="_blank"><i class="icon-share-alt"></i></a>)</g:if> <br/>

                  ISSN:<strong>${ie?.tipp?.title?.getIdentifierValue('ISSN')}</strong>, 
                  eISSN:<strong>${ie?.tipp?.title?.getIdentifierValue('eISSN')}</strong><br/>                            
                   Access: ${ie.availabilityStatus?.value}<br/>
                   Coverage Note: ${ie.coverageNote?:(ie.tipp?.coverageNote?:'')}<br/>
                   <g:if test="${ie.availabilityStatus?.value=='Expected'}">
                     on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessStartDate}"/>
                   </g:if>
                   <g:if test="${ie.availabilityStatus?.value=='Expired'}">
                     on <g:formatDate format="${session.sessionPreferences?.globalDateFormat}" date="${ie.accessEndDate}"/>
                   </g:if>
                   <g:if test="${params.mode=='advanced'}">
                     <br/> Access Start: <g:xEditable owner="${ie}" type="date" field="accessStartDate" /> (Leave empty to default to sub start date)
                     <br/> Access End: <g:xEditable owner="${ie}" type="date" field="accessEndDate" /> (Leave empty to default to sub end date)
                   </g:if>

                </td>
              
                <td>
                  <g:xEditableRefData owner="${ie}" field="medium" config='IEMedium'/>
                </td>
                <td>
                    <g:xEditable owner="${ie}" type="date" field="startDate" /><br/>
                    <g:xEditable owner="${ie}" type="date" field="endDate" />
                </td>
                <td>
                <g:render template="/templates/coreStatus" model="${['issueEntitlement': ie, 'date': params.asAt]}"/>
               <br/>

               <g:xEditableRefData owner="${ie}" field="coreStatus" config='CoreStatus'/>
                </td>
                <td>
                  <g:if test="${editable}"><g:link action="removeEntitlement" params="${[ieid:ie.id, sub:subscriptionInstance.id]}" onClick="return confirm('Are you sure you wish to delete this entitlement');">Delete</g:link></g:if>
                  <g:if test="${institutional_usage_identifier}">
                    <g:if test="${ie?.tipp?.title?.getIdentifierValue('ISSN')}">
                      | <a href="https://www.jusp.mimas.ac.uk/secure/v2/ijsu/?id=${institutional_usage_identifier.value}&issn=${ie?.tipp?.title?.getIdentifierValue('ISSN')}">ISSN Usage</a>
                    </g:if>
                    <g:if test="${ie?.tipp?.title?.getIdentifierValue('eISSN')}">
                      | <a href="https://www.jusp.mimas.ac.uk/secure/v2/ijsu/?id=${institutional_usage_identifier.value}&issn=${ie?.tipp?.title?.getIdentifierValue('eISSN')}">eISSN Usage</a>
                    </g:if>
                  </g:if>
                </td>
              </tr>
            </g:each>
          </g:if>
          </tbody>
          </table>
          </g:form>
        </dd>
      </dl>

      <div class="pagination" style="text-align:center">
        <g:if test="${entitlements}" >
          <bootstrap:paginate  action="index" controller="subscriptionDetails" params="${params}" next="Next" prev="Prev" max="${max}" total="${num_sub_rows}" />
        </g:if>
      </div>
    </div>



    <div id="magicArea">
    </div>


    <r:script language="JavaScript">
      function hideModal(){
        $("[name='coreAssertionEdit']").modal('hide');
      }

      function showCoreAssertionModal(){

        $("[name='coreAssertionEdit']").modal('show');
       
      }
      
      <g:if test="${editable}">

      function selectAll() {
        $('.bulkcheck').attr('checked', true);
      }

      function confirmSubmit() {
        if ( $('#bulkOperationSelect').val() === 'remove' ) {
          var agree=confirm("Are you sure you wish to continue?");
          if (agree)
            return true ;
          else
            return false ;
        }
      }
      </g:if>

      <g:if test="${params.asAt && params.asAt.length() > 0}"> $(function() {
        document.body.style.background = "#fcf8e3";
      });</g:if>
      
    </r:script>
  </body>
</html>
