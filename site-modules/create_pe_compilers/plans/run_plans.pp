
plan create_pe_compilers::run_plans(
  Array[String[1]] $vm_names,
  Hash $args_for_create_in_vcenter = {}
) {
  run_plan('create_pe_compilers::create_in_vcenter', $args_for_create_in_vcenter)
  run_plan('create_pe_compilers::configure_compilers', { 'vm_names' => $vm_names, })
}
