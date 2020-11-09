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

  <!-- 3 - Create a sequence of all necessary documents and wrap them in a root element: -->
  <p:wrap-sequence wrapper="wrapper-root-element">
    <p:with-input 
      pipe="
        template@main-pipeline 
        result@temps-file-xincluded 
        result@validate-city-ids-document
      "/>
  </p:wrap-sequence>

  <!-- 4 - Do the XSLT processing: -->
  <p:xslt>
    <p:with-input port="stylesheet" href="implementation-2.xsl"/>
  </p:xslt>

</p:declare-step>
