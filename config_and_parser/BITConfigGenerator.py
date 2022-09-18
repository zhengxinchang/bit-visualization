
# -*- coding:UTF-8 -*-
import json
import argparse
import logging
import os
from re import S
import sys
import logging

logging.basicConfig( level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')



class ConfigGenerator():
    def __init__(self,script):
        self.errors = []
        self.script = script
        self.rawconfig = self.extract_config(self.script)
        self.config = self.parseRawConfig(self.rawconfig)
        
    def get_results_and_errors(self):
        return (self.config,self.errors)

    def extract_config(self,script):
        scriptlines = []
        with open(script) as fins:
            for x in fins:
                if "%&%" in x:
                    scriptlines.append(x.split("%&%")[1].strip())
        logging.debug("\n".join(scriptlines))    
        return scriptlines


    def validate_blcok(self,block):
        if block['type'] not in ["output","string","number","color","select","file","file_textarea"]:
            self.errors.append("Option{}: Invalid option type: '{}'".format(block['cmdparam'],block['type']))
        
        if block['type'] == "string":
           
            if self.getNullValueSingle(block['range']) != None :
                self.errors.append("Option '{}': range in string type block should be None or emtpy. '{}' found".format(block['cmdparam'],block['range']))

        if block['type'] == "number":
            
            try:
                ok = float(block['default'])
            except:
                ok = None

            if ok == None and self.getNullValueSingle(block['default']) != None:
                self.errors.append("Option '{}': default in number type block should be a number '{}' found".format(block['cmdparam'],block['default']))

            # if not (isinstance(block['default'],int) or isinstance(block['default'],float) ) and self.getNullValueSingle(block['default']) != None:
            #     self.errors.append(f"Option '{block['cmdparam']}': default in number type block should be a number '{block['default']}' found")

    def get_template(self):
        
        template = {
                    "config_version": None, #
                    "program_type": None, # 
                    "author": None, 
                    "email": None,
                    "title": None,
                    "description": None,
                    "command": {
                        "cmd": None # 
                    },
                    "resource": {
                        "is_submit_to_queue": None, # 如果是false 则在线运行不提交到队列
                        "ppn": None,
                        "mem": None
                    },
                    "reference": [], 
                    "manual": None , # \n 分割多行
                    "options": []
                }


        return template

    def get_one_option_template(self,type):

        tmp = None
        if type =="file_textarea":
            tmp = {
            "name": None,
            "cmdparam": None,
            "type": "file_textarea", # file_textarea,同时提供一个文本上传按钮以及一个textarea, file：只提供文本上传按钮
            "range": None,
            "default": None,
            "help": None,
            "required": None,
            "add_option_in_cmd": None
        }
        elif type =="file":
            tmp = {
            "name": None,
            "cmdparam": None,
            "type": "file", # file_textarea,同时提供一个文本上传按钮以及一个textarea, file：只提供文本上传按钮
            "range": None,
            "default": None,
            "help": None,
            "required": None,
            "add_option_in_cmd": None
        }
        elif type =="color":
            tmp = {
            "name": None,
            "cmdparam": None,
            "type": "color",
            "range": None, 
            "help": None,
            "default": None,  #16进制， 例如 #abcaff
            "required": None,
            "add_option_in_cmd": None
        }
        elif type =="select":
            tmp = {
            "name": None,
            "cmdparam": None,
            "type": "select",  #受控词表类
            "default": None,
            "range": [], # {"optionA":"a"} optionA是展示给用户，a是传递给命令行
            "help": None,
            "required": None,
            "add_option_in_cmd": None

        }
        elif type =="string":
            tmp = {
            "name": None,
            "cmdparam":None,
            "type": "string", #文本类
            "range": None,
            "help": None,
            "default": None,
            "required": None,
            "add_option_in_cmd": None
        }
        elif type =="number":
            tmp = {
            "name": None,
            "cmdparam":None,
            "type": "number", # 数字类
            "default": None,
            "range": { # 数字类对应的取值范围
                "min": None, #如果是null，则表示无限制
                "max": None 
            },
            "help": None,
            "required": None,
            "add_option_in_cmd": None
        }
        
        elif type =="output":
            tmp = {
            "name": "out",
			"type": "output",
            "cmdparam":None,
            "default": None, # 如果不指定，则默认是run_output
			"result_files": [
			],
        }
        else:
            # self.errors.append("Option type must be one of [ output,number,string,color,file,file_textarea ]")
            tmp = {

            }
        return tmp

    def parseRawConfig(self,raw_config):
        configObj = self.get_template()
        is_one_open = False
        block = {}
        for line in raw_config:
            if "$META$" in line:
                if "config_version" in line:
                    configObj['config_version'] = self.getvalue(line,'$META$',"config_version")
                elif "program_type" in line:
                    configObj['program_type'] = self.getvalue(line,'$META$',"program_type")
                elif "author" in line:
                    configObj['author'] = self.getvalue(line,'$META$',"author")
                elif "email" in line:
                    configObj['email'] = self.getvalue(line,'$META$',"email")
                elif "title" in line:
                    configObj['title'] = self.getvalue(line,'$META$',"title")
                elif "description" in line:
                    configObj['description'] = self.getvalue(line,'$META$',"description")
                elif "cmd" in line:
                    configObj['command']['cmd'] = self.getvalue(line,'$META$',"cmd")
                elif "is_submit_to_queue" in line:
                    configObj['resource']['is_submit_to_queue'] = self.getBoolValue(line,'$META$',"is_submit_to_queue")
                elif "ppn" in line:
                    try:
                        configObj['resource']['ppn'] = int(self.getNumberValue(line,'$META$',"ppn"))
                    except:
                        configObj['resource']['ppn'] = None
                elif "mem" in line:
                    try:
                        configObj['resource']['mem'] = int(self.getNumberValue(line,'$META$',"mem"))
                    except:
                        configObj['resource']['mem'] = None
                elif "reference" in line:
                    configObj['reference'].append(self.getvalue(line,'$META$',"reference"))
                elif "manual" in line:
                    if isinstance(configObj['manual'],str):
                        configObj['manual'] += "\n" + self.getvalue(line,'$META$',"manual")
                    else:
                        configObj['manual'] = self.getvalue(line,'$META$',"manual")
            
            elif "$OPTION$" in line:

                if "option" in line and ("start" in line or "end" in line):
                    flag = self.getvalue(line,'$OPTION$',"option")
                    if flag =="start":
                        if is_one_open == True:
                            self.errors.append("Found not closed option block!")
                        else:
                            is_one_open =  True
                    elif flag == "end":
                            is_one_open =  False
                            # add one block to config 
                            # logging.debug(f"block:{block}")

                            self.validate_blcok(block=block)
                            tmplateOption = self.get_one_option_template(type=block['type'])

                            for x in ['name',"type","default","cmdparam"]:
                                tmplateOption[x] =  block[x]
                                if x == "default":
                                    tmplateOption[x] =  self.getNullValueSingle(block[x])

                            if tmplateOption["type"] in ['number',"string","select","color","file","file_textarea"]:
                                logging.debug("add_option_in_cmd:{}".format(block))
                                for x in ['add_option_in_cmd',"help","range","required"]:
                                    tmplateOption[x] =  block[x]
                                    if x == "required":
                                        tmplateOption[x] =  self.getBoolValueSingle(block[x])
                                    if x == "add_option_in_cmd":
                                        tmplateOption[x] =  self.getBoolValueSingle(block[x])
                                    if x == "range":
                                        tmplateOption[x] =  self.getNullValueSingle(block[x])
                            if tmplateOption["type"] == "number":
                                rangeraw = tmplateOption["range"]
                                rangerawList = rangeraw.strip().split(";")
                                tmplateOption["range"]={}
                                for x in rangerawList:
                                    if "MIN" in x.upper():
                                        if x.split(":")[1].strip().upper() == "-INF":
                                            tmplateOption["range"]["min"]="-INF"
                                        elif x.split(":")[1].strip().upper() == "INF":
                                            self.errors.append("block '{}': min value should not be -infinity!".format(block.get('name')))
                                        else:
                                      
                                            try:
                                                
                                                tmplateOption["range"]["min"] = float(x.split(":")[1])
                                            except:
                                                if "NONE" == x.split(":")[1].strip().upper():
                                                    tmplateOption["range"]["min"] = None
                                                else:
                                                    tmplateOption["range"]["min"] = x.split(":")[1].strip().upper()
                                    if "MAX" in x.upper():
                                        if x.split(":")[1].strip().upper() == "INF":
                                          tmplateOption["range"]["max"]="INF"
                                        elif x.split(":")[1].strip().upper() == "-INF":
                                            self.errors.append("block '{}': min value should not be infinity!".format(block.get('name')))                                        
                                        else:                                      
                                            try:
                                                
                                                tmplateOption["range"]["max"] =float(x.split(":")[1]) 
                                            except:
                                                if "NONE" == x.split(":")[1].strip().upper():
                                                    tmplateOption["range"]["max"] = None
                                                else:
                                                    tmplateOption["range"]["max"] = x.split(":")[1].strip().upper()
                                if block['default'].strip().upper() == "INF":
                                     tmplateOption["default"]="INF"
                                elif block['default'].strip().upper() == "-INF":
                                     tmplateOption["default"]="-INF"                                     
                                else:                                      
                                
                                    try:
                                        tmplateOption["default"] = float(block['default'])
                                    except:
                                        
                                        if "NONE" == block['default'].strip().upper():
                                            tmplateOption["default"] =  None
                                        else:
                                            tmplateOption["default"] = block['default'].strip().upper()

                            if tmplateOption["type"] == "select":
                                
                                try:
                                    rangeraw = tmplateOption["range"]
                                    rangelist = json.loads(rangeraw)
                                    tmplateOption["range"] = rangelist
                                except Exception as e:
                                    self.errors.append("Found error in '{}', reason {},please provide range like a:10;b:11".format(block.get('name'),str(e)))

                              

                            if tmplateOption["type"] == "output":
                                
                                tmplateOption['result_files'] =[]

                                for x in block['result_files']:
                                    
                                    tmplateOption['result_files'].append(
                                        {
                                            "file_name":x.split("|")[0],
                                            "show_in_page": self.getBoolValueSingle( x.split("|")[1].split(":")[1])
                                        }
                                    )

                            configObj['options'].append(tmplateOption)
                            # clean tmp block
                            block={}
                else:
                    m = self.getkeyvalue(line,'$OPTION$')  
                    if m[0] == "result_files":  
  
                        if m[0] not in block.keys():
                            block[m[0]] = [m[1]]
                        else:
                            block[m[0]].append(m[1])
             
                    else:
                        block[m[0]] =m[1]

        return configObj
    
    def getkeyvalue(self,line,prefix):
            x = self.clean_str(line.replace(prefix,""))
            if "=" in x:
                y = x.split("=")
                return (self.clean_str(y[0]),self.clean_str(y[1]))
            else:
                self.errors.append(
                    "Config format error: '=' not found in {}".format(line)
                )
                return "ERROR!"        

    def getvalue(self,line,prefix,key=None):
        if key==None:
            return self.clean_str(line.replace(prefix,""))
        else:
            x = self.clean_str(line.replace(prefix,""))
            if "=" in x:
                
                y = x.split("=")
                return self.clean_str(y[1])

            else:
                self.errors.append(
                    "Config format error: '=' not found in {line}".format(line)
                )
    def getBoolValueSingle(self,v):
        if v.strip().upper() in ["T","TRUE"]:
            return True
        elif v.strip().upper() in ["F","FALSE"]:
            return False
        else:
            self.errors.append("Found invalid Bool value '{}' ".format(v))
            return None 

    def getNullValueSingle(self,v):
        if v.strip().upper() in ["NONE","NULL"]:
            return None
        else:
            return v

    def getBoolValue(self,line,prefix,key=None):
        v = self.getvalue(line,prefix,key)
        if v.strip().upper() in ["T","TRUE"]:
            return True
        elif v.strip().upper() in ["F","FALSE"]:
            return False
        else:
            self.errors.append("Found invalid Bool value {} ".format(v))
            return None 

    def getNumberValue(self,line,prefix,key=None):
        v = self.getvalue(line,prefix,key)
        try:
            f = float(v)
            return v
        except Exception as e:
            self.errors.append("Found invalid Bool value {}".format(v))
            return None

    def clean_str(self,s):
        k = s.strip()
        return k

if __name__=="__main__":
    
    parser = argparse.ArgumentParser(prog="Config Generator for BIT")
    parser.add_argument("-s","--source",help="source file",required=True)
    parser.add_argument("-o","--output",help="output file",required=True)
    args = parser.parse_args()

    if not os.path.exists(args.source):
        print("Source file not found: {} ".format(args.source))
        sys.exit(1)

    confgen = ConfigGenerator(script=args.source)
    confjson, errors = confgen.get_results_and_errors()

    
    print("\n********The Configuration file is:**********")
    print(json.dumps(confjson,indent=4))

    print("\n********Format validation:**********")
    if len(errors) >0:
        print("Errors found!:")
        print("\n".join(errors))
    else:
        print("No error found!")
    with open(args.output,"w") as outf:
        outf.write(json.dumps(confjson,indent=4,sort_keys=True))
