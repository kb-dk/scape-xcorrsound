# Access copies


Jeg tror at DOMS tingene kan findes her: `zone1.isilon.sblokalnet:/ifs/archive/radio-tv`

For kuana ting er det `zone1.isilon.sblokalnet:/ifs/archive/bart-access-copies-radio`


Vores XSLT har

```xml
<fileRef>
  <xsl:for-each select="//oai:metadata/xip:Manifestation">
    <xsl:if test="xip:Active='true' and xip:TypeRef='2'">
      <xsl:value-of select="xip:ManifestationFile/xip:FileRef"/>
    </xsl:if>
  </xsl:for-each>
</fileRef>
```

og så vidt jeg forstår burde det være nok til at kunne slå filen op. En søgning på kanal + tidsinterval burde være trivielt. Prøv f.eks. 
```bash
curl -s 'http://rhea.statsbiblioteket.dk:50001/solr/doms.1.stage/select?wt=json&fl=authID,shortformat&q=radioavisen' | jq .
```


Mere præcist opslag på kanal og tidspunkt:

```bash
curl -gs 'http://rhea.statsbiblioteket.dk:50001/solr/doms.1.prod/select' -d 'wt=json&fl=authID,shortformat,coverage_start_full&q=channel_name:drp1 AND coverage_start_full:[2018-04-05T04:59:00Z TO *] AND coverage_end_full:[* TO 2018-04-05T05:59:59Z]' | jq .
```

Begræns til materialetype `q=lma_long:radio`


cut mellem doms og kuana 7. august 2018

`develro@phoebe:/radio-tv`

curl -s 'http://rhea.statsbiblioteket.dk:50001/solr/doms.1.prod/select?wt=json&fl=authID,sort_title&q=Radio' | jq '.response.docs[] | .authID |.[2]' | sort -u | grep -v "null" | sed 's/"//g' | sed -E 's|((.{2})(.{2})(.{2}).+)|/bart-access-copies-radio/\2/\3/\4/\1|' | xargs -r -i file {}


Se extractor på <https://sbprojects.statsbiblioteket.dk/stash/projects/SSYS/repos/ismirmediestreamextractor/browse>