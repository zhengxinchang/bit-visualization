#!/usr/bin/env python3
from typing import NoReturn
import click
import os
import re


template = """

<!-- for xml file can not contain these special characters,such as > & < ",use &gt; &amp; &lt; &quot; to replace when neccessay -->
<pipeline name="{CONFIG:MODULENAME}">
	<!-- the module name must be the same as the pipeline name for the application -->
	<!-- the email attribute is used to send notify email to you during deployment procedure -->
	<module name="{CONFIG:APPNAME}" number="1" ismust="1" submittype="1" email="zhengxinchang@big.ac.cn">
		<desc> {CONFIG:DESC} </desc>
		<!-- you only need to fill the main script name -->
		<class> {CONFIG:CLASS} </class>
		<inputs>
			<!-- eletype can be textbox/select/checkbox/file/textarea -->
			<!-- isacqure means can not be empty,0 means allow empty -->
			<!-- isshow means whether this item will show in submit page,1 means show -->
			<!-- whitespace means whether allow white space between command param and item value,1 means allow white space -->

{CONFIG:INPUT}

		</inputs>
		<outputs>
			<!-- eletype can be textbox/checkbox -->
			<!-- whitespace means whether allow white space between command param and item value,1 means allow white space -->
			<!-- ispageshow means whether this item will show in the submit page,1 means show -->
			<!-- isresultshow means whether this item value will  show in the result page after task  finish,1 means show -->
			<param name="outdir" cmdparam="--outdir"  desc="" eletype="textbox"  isresultshow="1" whitespace="1" ispageshow="0">{CONFIG:OUTFINENAME}</param>
			
		</outputs>
		<reference> {CONFIG:REFERENCE} </reference>
		<help> {CONFIG:HELP} </help>
	</module>
</pipeline>


"""


@click.command()
@click.option("-r","--rfile",required=True)
@click.option("-x","--xmlfile",required=True)
def main(rfile,xmlfile):
    
    outxml = []
    config = {}
    with open(rfile) as fr:
        for r in fr:
            if r.startswith("#CONFIG"):
                rconf = r.lstrip('#').strip().split("=")
                if rconf[0] not in config.keys():

                    config[rconf[0]] = rconf[1]
                else:
                    config[rconf[0]] =config[rconf[0]] +"\n"+ rconf[1]

            if not r.strip().startswith("make_option"):
                continue
                
            xml_cmdparam=None
            xml_desc=None
            xml_name=None
            xml_default=None
            
            # print(r.replace('"',"'"))
            print(r)
            if "#type=" in r:
                print(r)
                list_r = r.strip().split('#')
                r = list_r[0]
                typedata = list_r[1].strip()
                typedata = typedata.lstrip("type=")
                if typedata.startswith("select"):
                    typelist = typedata.split(":")
                    mytype = typelist[0]
                  
                    myvaluelist = typelist[1].split(",")
                    myvalueStr = []
                    for  x in myvaluelist:
                        if "*" not in x:
                            myvalueStr.append( x.replace("*","")+"=" + x.replace("*",""))
                        else:
                            myvalueStr.append( x.replace("*","")+"=" + x.replace("*",""))
                            mydefault = x.replace("*","")

                elif typedata.startswith("file"):
                    mytype = "file"
                

                r=r.strip().strip(",").lstrip("make_option(").rstrip(")")
                s = [i.strip() for i in r.split(",")]
            
                for i in s:
                    if i.startswith("c("):
                        i=i.lstrip('c("').rstrip('")').strip()
                        assert i.startswith("--") , "param format error {}".format(i)
                        xml_cmdparam = i 
                        xml_name = i.lstrip("--")
                    if i.startswith("default"):
                        a,b = i.split("=")
                        xml_default = b.strip('"')
                    if i.startswith("help"):
                        
                        c,d = i.split("=")
                        xml_desc = d.replace(")","").strip('"').replace('"',"'")

                if xml_cmdparam ==None :
                    raise Exception("option error{}".format("xml_cmdparam"))
                if xml_name ==None :
                    raise Exception("option error{}".format("xml_name"))
                if xml_default ==None :
                    raise Exception("option error{}".format("xml_default"))
                    
                if xml_desc == None:
                    xml_desc = ""

                if xml_name !="outdir":
                    if typedata.startswith("file"):
                        oneline  =  """<param name="{0}" isacquire="1" cmdparam="{1}"  desc="{2}" eletype="{4}"  isshow="1" whitespace="1" default="{3}"></param>""".format(
                            xml_name,
                            xml_cmdparam,
                            xml_desc,
                            xml_default,
                            mytype
                        )
                        outxml.append(
                            "\t"*3 + oneline
                        )
                    else:
                        oneline  =  """<param name="{0}" isacquire="1" cmdparam="{1}"  desc="{2}" eletype="{4}"  isshow="1" whitespace="1" default="{3}">{5}</param>""".format(
                            xml_name,
                            xml_cmdparam,
                            xml_desc,
                            mydefault,
                            mytype,
                            ",".join(myvalueStr)
                        )
                        outxml.append(
                            "\t"*3 + oneline
                        )


            else:
                r=r.strip().strip(",").lstrip("make_option(").rstrip(")")
                s = [i.strip() for i in r.split(",")]
              
                for i in s:
                    print(i)
                    if i.startswith("c(") :
                        i=i.lstrip('c("').rstrip('")').strip()
                        assert i.startswith("--") , "param format error {}".format(i)
                        xml_cmdparam = i 
                        xml_name = i.lstrip("--")
                        
                    if i.startswith("default") and "=" in i:
                        
                        a,b = i.split("=")
                        xml_default = b.strip('"')
                    if i.startswith("help") and "=" in i:
                        c,d = i.split("=")
                        xml_desc = d.replace(")","").strip('"').replace('"',"'")

                if xml_cmdparam ==None :
                    raise Exception("option error{}".format("xml_cmdparam"))
                if xml_name ==None :
                    raise Exception("option error{}".format("xml_name"))
                if xml_default ==None :
                    raise Exception("option error{}".format("xml_default"))
                    
                if xml_desc == None:
                    xml_desc = ""

                if xml_name !="outdir":
                    oneline  =  """<param name="{}" isacquire="1" cmdparam="{}"  desc="{}" eletype="textbox"  isshow="1" whitespace="1" default="{}"></param>""".format(
                        xml_name,
                        xml_cmdparam,
                        xml_desc,
                        xml_default,
                    )
                    outxml.append(
                        "\t"*3 + oneline
                    )
    # print(outxml)

    # print(outxml)
    tempout= template.replace("{CONFIG:INPUT}","\n".join(outxml))

    # print(config)
    for k ,v in config.items():
        tempout = tempout.replace('{'+k+'}',v)
    print(tempout)
    out = open(xmlfile,'w')
    out.write(tempout)
    out.close()
if __name__ == "__main__":
    main()
    # main("./plot_oncoprint.r","./plot_oncoprint.xml")

