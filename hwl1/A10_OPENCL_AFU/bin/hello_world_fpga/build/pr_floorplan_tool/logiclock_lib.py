import sys
import re

class rect_region(object):
	def __init__(self,x1,y1,x2,y2,name="",logiclocked=False,res_place=False,core_only=True,partial=False):
		self.x1 = x1
		self.y1 = y1
		self.x2 = x2
		self.y2 = y2
		self.name = name
		self.logiclocked = logiclocked
		self.partial = partial
		if res_place == True:
			self.res_place = "ON"
		else:
			self.res_place = "OFF"
		if core_only == True:
			self.core_only = "ON"
		else:
			self.core_only = "OFF"
	
class logiclock_solver(object):
	def __init__(self,partitionname,name,x_max=224,y_max=224):
		self.constraints = []
		self.regions = {}
		self.partitionname = partitionname
		self.name = name
		self.x_max = x_max
		self.y_max = y_max
		
	def add_region(self,rect):
		if not rect.partial:
			self.constraints += [rect]
		if rect.name in self.regions:
			self.regions[rect.name] += [rect]
		else:
			self.regions[rect.name] = [rect]

	def point_reserved(self,x,y,cons):
		if x >= self.x_max+1:
			return True
		if y >= self.y_max+1:
			return True
		for rect in cons:
			if ((x >= rect.x1) & (x <= rect.x2) & (y >= rect.y1) & (y <= rect.y2)):
				return True
		return False


	def find_start_end_vert(self,col,row,cons):
		ret = [-1,-1]
		for y in range(row,self.y_max+2):
			if self.point_reserved(col,y,cons):
				ret = [row,y-1]
				return ret
		return ret

	def find_start_end_horiz(self,line,col,cons):
		if line[0] == -1:
			return None
		for x in range(col+1,self.x_max+2):
			for y in range(line[0],line[1]+1):
				if self.point_reserved(x,y,cons):
					return rect_region(col,line[0],x-1,line[1])

	def solve(self,x=0,y=0):
		y_min = y
		x_min = x
		my_cons = self.constraints
		solution = []
		while x < self.x_max+1:
			while y < self.y_max+1:
				if self.point_reserved(x,y,my_cons):
					y += 1
					continue
				line = self.find_start_end_vert(x,y,my_cons)
				r = self.find_start_end_horiz(line,x,my_cons)
				if r != None:
					y = r.y2 + 1
					my_cons += [r]
					solution += [r]
					continue
				y += 1
			x += 1
			y = y_min
		return solution
		
	def print_solution(self):
		solution = self.solve()
		sol = ""
		for rect in solution:
			sol += "X%i Y%i X%i Y%i;" % (rect.x1,rect.y1,rect.x2,rect.y2)
		print "#####################################################"
		print "# Main PR Partition -- %s" %(self.partitionname)
		print "#####################################################"
		print "set_instance_assignment -name PARTITION %s -to %s" %(self.partitionname,self.name)
		print "set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to %s" %(self.name)
		print "set_instance_assignment -name RESERVE_PLACE_REGION ON -to %s" %(self.name)
		print "set_instance_assignment -name PARTIAL_RECONFIGURATION_PARTITION ON -to %s" %(self.name)
		print "set_instance_assignment -name PLACE_REGION \"%s\" -to %s" %(sol,self.name)
		print "set_instance_assignment -name ROUTE_REGION \"X0 Y0 X%i Y%i\" -to %s" %(self.x_max,self.y_max,self.name)
		print ""
		for region in self.regions:
			if self.regions[region][0].logiclocked == False:
				continue
			if self.regions[region][0].partial:
				type = "Partial"
			else:
				type = "Static"
			print "#####################################################"
			print "# Logic Locked %s Region -- %s" %(type,self.regions[region][0].name)
			print "#####################################################"
			sol = ""
			for rect in self.regions[region]:
				sol += "X%i Y%i X%i Y%i;" % (rect.x1,rect.y1,rect.x2,rect.y2)
			print "set_instance_assignment -name PLACE_REGION \"%s\" -to %s" %(sol,self.regions[region][0].name)
			print "set_instance_assignment -name CORE_ONLY_PLACE_REGION %s -to %s" %(self.regions[region][0].core_only,self.regions[region][0].name)
			print "set_instance_assignment -name RESERVE_PLACE_REGION %s -to %s" %(self.regions[region][0].res_place,self.regions[region][0].name)
			print ""

	def print_solution_hpr(self,hpr_outfilename="None"):
		if hpr_outfilename != "None":
			hproutfile = open(hpr_outfilename,"w+")
			print "#Writing the following Logic Lock and HPR floorplan information to " + hpr_outfilename + ", too."
			print ""
		solution = self.solve()
		sol = ""
		for region in self.regions:
			if self.regions[region][0].logiclocked == False:
				continue
			sol2 = ""
			for rect in self.regions[region]:
				sol2 += "X%i Y%i X%i Y%i;" % (rect.x1,rect.y1,rect.x2,rect.y2)
			#sol2 = sol2[:-1]
			print "set_instance_assignment -name CORE_ONLY_PLACE_REGION %s -to \"%s\"" %(self.regions[region][0].core_only,self.regions[region][0].name)
			print "set_instance_assignment -name RESERVE_PLACE_REGION %s -to \"%s\"" %(self.regions[region][0].res_place,self.regions[region][0].name)
			print "set_instance_assignment -name PLACE_REGION \"%s\" -to \"%s\"" %(sol2,self.regions[region][0].name)
			print ""
			if hpr_outfilename != "None":
				hproutfile.write("set_instance_assignment -name CORE_ONLY_PLACE_REGION %s -to \"%s\"\n" %(self.regions[region][0].core_only,self.regions[region][0].name))
				hproutfile.write("set_instance_assignment -name RESERVE_PLACE_REGION %s -to \"%s\"\n" %(self.regions[region][0].res_place,self.regions[region][0].name))
				hproutfile.write("set_instance_assignment -name PLACE_REGION \"%s\" -to \"%s\"\n" %(sol2,self.regions[region][0].name))
				hproutfile.write("\n")
			sol += sol2
		for rect in solution:
			sol += "X%i Y%i X%i Y%i;" % (rect.x1,rect.y1,rect.x2,rect.y2)
		sol = sol[:-1]
		print "# HPR Partition -- %s\n" %(self.partitionname)
		print "set_instance_assignment -name PARTITION %s -to \"%s\"" %(self.partitionname,self.name)
		print "set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to \"%s\"" %(self.name)
		print "set_instance_assignment -name RESERVE_PLACE_REGION ON -to \"%s\"" %(self.name)
		print "set_instance_assignment -name PLACE_REGION \"%s\" -to \"%s\"" %(sol,self.name)
		print "set_instance_assignment -name ROUTE_REGION \"X0 Y0 X%i Y%i\" -to \"%s\"" %(self.x_max,self.y_max,self.name)
		print ""
		if hpr_outfilename != "None":
			hproutfile.write("# HPR Partition -- %s\n" %(self.partitionname))
			hproutfile.write("set_instance_assignment -name PARTITION %s -to \"%s\"\n" %(self.partitionname,self.name))
			hproutfile.write("set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to \"%s\"\n" %(self.name))
			hproutfile.write("set_instance_assignment -name RESERVE_PLACE_REGION ON -to \"%s\"\n" %(self.name))
			hproutfile.write("set_instance_assignment -name PLACE_REGION \"%s\" -to \"%s\"\n" %(sol,self.name))
			hproutfile.write("set_instance_assignment -name ROUTE_REGION \"X0 Y0 X%i Y%i\" -to \"%s\"\n" %(self.x_max,self.y_max,self.name))
		hproutfile.close()

#
#
#  Example Implementation
#
#

if __name__ == '__main__':			
	pr = logiclock_solver(partitionname="green_region",name="fpga_top|inst_green_bs")
	pr.add_region(rect_region(0,47,38,167,name="BBS",logiclocked=False))
	pr.add_region(rect_region(139,0,142,4,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,73,138,90,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,128,138,145,name="mem|ddr4a",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(139,0,142,4,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,73,138,90,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.add_region(rect_region(129,128,138,145,name="mem|ddr4b",logiclocked=True,res_place=False,core_only=True))
	pr.print_solution()
