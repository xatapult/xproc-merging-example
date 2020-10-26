<p:declare-step version="3.0" name="main-pipeline"
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- 1 - Declare the input ports: -->
  <p:input port="template" primary="false" sequence="false" 
    content-types="xml" href="../data/template.xml"/>
  <p:input port="temps" primary="false" sequence="false" 
    content-types="xml" href="../data/temps.xml"/>
  <p:input port="city-ids" primary="false" sequence="false" 
    content-types="xml" href="../data/city-ids.xml"/>

  <!-- 2 - Declare the output port: -->
  <p:output port="result" primary="true" sequence="false" 
    content-types="xml"
    serialization="map{'method': 'html', 'indent': true()}"/>

  <!-- ======================================================================= -->

  <!-- 3 - Create a temporary file and catch its name: -->
  <p:file-create-tempfile delete-on-exit="true" suffix=".xml"/>
  <p:variable name="temps-filename" as="xs:string" select="string(.)"/>

  <!-- 4 - Compute the full temperature document, write it the temporary file: -->
  <p:xinclude>
    <p:with-input pipe="temps@main-pipeline"/>
  </p:xinclude>
  <p:store href="{$temps-filename}" name="write-temps-to-disk"/>

  <!-- 5 - Validate the city-ids document. If this is invalid the pipeline will fail: -->
  <p:validate-with-xml-schema>
    <p:with-input pipe="city-ids@main-pipeline"/>
    <p:with-input port="schema" href="../data/xsd/city-ids.xsd"/>
  </p:validate-with-xml-schema>

  <!-- 6 - Catch the name of the city-ids document: -->
  <p:variable name="city-ids-filename" as="xs:string" select="base-uri(.)" 
    pipe="city-ids@main-pipeline"/>

  <!-- 7 - Do the XSLT processing: -->
  <p:xslt 
    parameters="map{
      'temps-filename': $temps-filename, 
      'city-ids-filename': $city-ids-filename
    }" 
    depends="write-temps-to-disk">
    <p:with-input pipe="template@main-pipeline"/>
    <p:with-input port="stylesheet" href="implementation-1.xsl"/>
  </p:xslt>

</p:declare-step>
