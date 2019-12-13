# Create PE compilers in vSphere
plan create_pe_compilers::create_in_vcenter(
  String[1] $vm_folder,
  Array[String[1]] $vm_names,
  String[1] $resource_pool,
  String[1] $target_data_store,
  String[1] $source,
  Enum[vm, template] $source_type = template,
  Optional[String] $annotation,
  Optional[String] $customization_spec,
) {
  apply_prep('localhost')
  $results = apply('localhost', _catch_errors => true) {
    $vm_names.each |$vm_name| {
      vsphere_vm { "${vm_folder}/${vm_name}":
        ensure             => running,
        source             => $source,
        source_type        => $source_type,
        resource_pool      => $resource_pool,
        datastore          => $target_data_store,
        cpus               => '5',
        memory             => '32768',
        annotation         => $annotation,
        customization_spec => $customization_spec,
      }
    }
  }

  # create_pe_compilers::plan_output_apply_result($results)

  $results.each |$result| {
    if $result.ok {
      notice($result.report)
    } else {
      notice($result.error.message)
    }
  }
}
