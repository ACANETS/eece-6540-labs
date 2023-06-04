post_message "Running compile_script.tcl script"

# get flow type (from quartus(args) variable)
set flow [lindex $quartus(args) 0]

if {$flow eq "base"} {
  post_message "OpenCL BSP base revision compile..."

  # simplified PR Quartus flow for afu_base PR_IMPL revision
  qexec "quartus_syn --read_settings_files=on --write_settings_files=off dcp -c afu_base"
  qexec "quartus_fit --read_settings_files=on --write_settings_files=off dcp -c afu_base"
  qexec "quartus_asm --read_settings_files=on --write_settings_files=off dcp -c afu_base"
  qexec "quartus_sta dcp -c afu_base"

  # export bsp_interface partition
  qexec "quartus_cdb dcp -c afu_base --export_block bsp_interface --snapshot final --file bsp_interface.qdb"

  # generate PR programming files
  qexec "quartus_cpf -c output_files/afu_base.green_region.pmsf output_files/afu_base.green_region.rbf"

}

if {$flow eq "import"} {
  post_message "OpenCL BSP import revision compile..."

  # simplified PR Quartus flow for afu_import PR_IMPL revision
  qexec "quartus_syn --read_settings_files=on --write_settings_files=off dcp -c afu_import"
  qexec "quartus_fit --read_settings_files=on --write_settings_files=off dcp -c afu_import"
  qexec "quartus_asm --read_settings_files=on --write_settings_files=off dcp -c afu_import"
  qexec "quartus_sta dcp -c afu_import"

  # generate PR programming files
  qexec "quartus_cpf -c output_files/afu_import.green_region.pmsf output_files/afu_import.green_region.rbf"
}
