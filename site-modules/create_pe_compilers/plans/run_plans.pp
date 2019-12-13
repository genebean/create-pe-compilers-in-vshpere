
plan create_pe_compilers::run_plans(
  Array[String[1]] $vm_names = [
      'pe-compiler-prod-1',
      'pe-compiler-prod-2',
      'pe-compiler-prod-3',
      'pe-compiler-prod-4',
      'pe-compiler-prod-5',
      'pe-compiler-prod-7',
  ],
) {
  $args_for_create_in_vcenter = {
    'vm_folder'          => '/vcenter-prod1.ops.puppetlabs.net/opdx1/ops/production',
    'vm_names'           => $vm_names,
    'target_data_store'  => 'tintri-opdx-1-puppet-infrastructure',
    'source'             => '/vcenter-prod1.ops.puppetlabs.net/opdx1/templates/ops/centos-7.6.1810-with-puppet-0.0.1',
    'customization_spec' => 'Linux Customization',
    'annotation'         => 'PE Compiler deployed 25 Sept 2019',
    'resource_pool'      => '/puppet1',
  }
  run_plan('create_pe_compilers::create_in_vcenter', $args_for_create_in_vcenter)

  $args_for_configure_compilers = {
    'vm_names' => $vm_names,
  }
  run_plan('create_pe_compilers::configure_compilers', $args_for_configure_compilers)
}
