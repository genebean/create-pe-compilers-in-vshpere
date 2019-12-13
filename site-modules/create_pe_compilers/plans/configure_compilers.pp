plan create_pe_compilers::configure_compilers(
  Array[String[1]] $vm_names,
  String[1] $domain = 'ops.puppetlabs.net',
  String[1] $master = 'pe-mom1-prod.ops.puppetlabs.net',
  String[1] $dns_alt_names = 'puppet,puppet.ops.puppetlabs.net,puppet.puppetlabs.net,pemaster.puppetlabs.net,pemaster.ops.puppetlabs.net,puppet-next.ops.puppetlabs.net,puppet-next.puppetlabs.net',
){
  $_command_options = {
    '_catch_errors' => false,
  }

  # disable the master's firewall
  run_command("sudo -i puppet agent --disable 'Agent disabled by bolt plan for deploying compilers'", $master, $_command_options)
  run_command('sudo systemctl stop iptables', $master, $_command_options)

  $_puppet = 'sudo -i puppet agent --onetime --no-daemonize --no-usecacheonfailure --no-splay --verbose --show_diff'

  $results = $vm_names.each |$vm_name| {
    $_target = "${vm_name}.${domain}"

    # make hosts entry to fix curl
    run_command('sudo -i puppet resource host puppet.ops.puppetlabs.net ip=10.32.22.222', $_target, $_command_options)

    # remove the current puppet agent so that the installer can set the dns alt names
    run_command('sudo yum remove -y puppet-agent; rm -f /etc/puppetlabs/puppet/puppet.conf*', $_target, $_command_options)

    # do curl|bash install
    $_all_dns_alt_names = "${vm_name},${dns_alt_names}"
    $cmd = "curl -k https://${master}:8140/packages/current/install.bash | sudo bash -s -- main:dns_alt_names=${_all_dns_alt_names} --puppet-service-ensure stopped --puppet-service-enable false"
    run_command($cmd, $_target, $_command_options)

    # submit cert for signing
    run_command('sudo -i puppet ssl submit_request', $_target, $_command_options)

    # sign the newly generated cert
    run_command("sudo -i puppetserver ca sign --certname ${_target}", $master, $_command_options)

    # pin the new compiler to the 'PE Master' node group
    run_command("sudo -i puppet resource pe_node_group 'PE Master' pinned='${_target}'", $master, $_command_options)

    # run puppet on the new compiler twice
    run_command($_puppet, $_target, $_command_options)
    run_command($_puppet, $_target, $_command_options)

    # clean up hosts entry
    run_command('sudo -i puppet resource host puppet.ops.puppetlabs.net ensure=absent', $_target, $_command_options)
  }

  # re-enable the master's firewall
  run_command('sudo systemctl start iptables', $master, $_command_options)
  run_command('sudo -i puppet agent --enable', $master, $_command_options)

  # run puppet on the master
  run_command($_puppet, $master, $_command_options)
}