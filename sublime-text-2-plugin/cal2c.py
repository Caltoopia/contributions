import sublime, sublime_plugin
import re
import os
import subprocess

class Cal2cCommand(sublime_plugin.TextCommand):
    def run(self, edit):
    	self.save()
    	self.save_selections()
    	p = self.get_params()
    	cmd = ["java", "-jar", p['cal2c'], "--top", p['top_nw'], "--path", p['path'], "--output", p['output'], "--runtime", p['runtime']]
    	## http://www.sublimetext.com/forum/viewtopic.php?f=6&t=5345
    	c2c = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
    	if c2c.stdout is not None :
    		log = c2c.stdout.readlines()     		
    		f = open(p['log'], 'w')
    		f.writelines(log)
    		f.close()
    	msg = []
    	if c2c.stderr is not None : 
    		msg = c2c.stderr.readlines()	
    		f = open(p['errlog'], 'w')
    		f.writelines(msg)
    		f.close()
    	if msg: 
    		print msg
    		self.highlight_errors(log)
    	else:
    		self.restore_selections()	


    def get_params(self):	
    	src_dir = os.path.dirname(self.view.file_name())
    	params = {}
    	params['top_nw'] = self.find_target()
    	params['cal2c'] = os.path.expandvars(os.getenv('CAL2C', 'Cal2C.jar'))
    	params['runtime'] = os.path.expandvars(os.getenv('CAL_RUNTIME', 'actors_rts'))
    	params['path'] = os.path.expandvars(":".join([src_dir, os.getenv('CAL_SYSTEM_DIRS', 'System')]))
    	params['output'] = os.path.expandvars(src_dir+"/c_source")
    	params['log'] = os.path.expandvars(src_dir)+"/"+params['top_nw']+".log"
    	params['errlog'] = os.path.expandvars(src_dir)+"/"+params['top_nw']+"_error.log"
    	return params

    def save(self):
        self.view.run_command("save")

    def find_target(self):	
    	# Extract namespace and network
    	# FIXME: Elaborate later.
    	self.view.run_command("select_all", {})
    	sels = self.view.sel()
    	sel = sels[0]

    	code = self.view.substr(sel)
    	regex = re.compile("namespace\s+(\w+)")
    	ns = regex.findall(code)
    	regex = re.compile("network\s+(\w+)")
    	nw = regex.findall(code)
    	if nw:
    		ns.append(nw[0])

    	return ".".join(ns)	

    def save_selections(self):
    	## FIXME: Deep copy needed here
    	self.saved_selections = self.view.sel() #.copy() RegionSet has no copy() method

    def restore_selections(self):
    	self.view.sel().clear()
    	for sel in self.saved_selections:
    		self.view.sel().add(sel)

    def highlight_errors(self, loglines):
    	pass

        