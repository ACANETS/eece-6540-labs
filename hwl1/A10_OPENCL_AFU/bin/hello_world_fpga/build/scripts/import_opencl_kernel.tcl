# (C) 2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License Subscription
# Agreement, Intel MegaCore Function License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Intel and sold by
# Intel or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#imports/links opencl compiler generated files into build directory

proc get_list_from_file {fname} {
    set f [open $fname r]
    set data [split [string trim [read $f]]]
    close $f
    return $data
}

set bsp_filelist [get_list_from_file ../bsp_dir_filelist.txt]

proc copy_dir {src_dir dst_dir} {
	#puts "copy_dir: $src_dir $dst_dir"
	set glob_src_path [file join $src_dir *]
	foreach i [glob -nocomplain $glob_src_path] {
		set dst_path [file join $dst_dir [file tail $i]]
		if [file isdirectory $dst_path] {
			copy_dir $i $dst_path
		} else {
			file copy -force $i $dst_path
		}
	}
}

foreach i [glob -nocomplain ../*] {
	set basefile [file tail $i]
	if {[lsearch -exact $bsp_filelist $basefile] == -1} {
		if [file isdirectory $i] {
			#puts "copy_dir $i $basefile"
			if { ![file exists $basefile] } {
				file mkdir $basefile
			}
			copy_dir $i $basefile
		} else {
			if {[file exists $basefile]} {
				file delete -force $basefile
			}
			
			file link -symbolic $basefile $i
		}
		puts "importing: $i"
	}
}

