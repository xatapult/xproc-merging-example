<p:declare-step version="3.0" name="main-pipeline"
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  
  <p:input port="template" primary="false" sequence="false" 
    content-types="xml" href="../data/template.xml"/>
  <p:input port="temps" primary="false" sequence="false" 
    content-types="xml" href="../data/temps.xml"/>
  <p:input port="city-ids" primary="false" sequence="false" 
    content-types="xml" href="../data/city-ids.xml"/>
  
  <p:output port="result" primary="true" sequence="false" 
    content-types="xml"
    serialization="map{'method': 'html', 'indent': true()}"/>
  
  <!-- ======================================================================= -->

  <!-- 1 - Validate the city-ids document. If this is invalid the pipeline will fail: -->
  <p:validate-with-xml-schema name="validate-city-ids-document">
    <p:with-input pipe="city-ids@main-pipeline"/>
    <p:with-input port="schema" href="../data/xsd/city-ids.xsd"/>
  </p:validate-with-xml-schema>

  <!-- 2 - Compute the full temperature document -->
  <p:xinclude name="temps-file-xincluded">
    <p:with-input pipe="temps@main-pipeline"/>
  </p:xinclude>

  <!-- 3 - Refer to the documents using document-node() type variables: -->
  <p:variable name="city-temps-document" as="document-node()" select="."/>
  <p:variable name="city-ids-document" as="document-node()" select="." 
    pipe="result@validate-city-ids-document"/>

  <!-- 4 - Do the XSLT processing: -->
  <p:xslt parameters="map{ 
      'city-temps-document': $city-temps-document, 
      'city-ids-document'  : $city-ids-document 
    }">
    <p:with-input pipe="template@main-pipeline"/>
    <p:with-input port="stylesheet" href="implementation-3.xsl"/>
  </p:xslt>

</p:declare-step>
