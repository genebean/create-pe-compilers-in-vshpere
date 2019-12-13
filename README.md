# Create PE Compilers in vShpere

## Prep work

To use this setup you will have to take a few preparatory steps (these assume you are on macOS):

1. Run `sudo /opt/puppetlabs/bolt/bin/gem install rbvmomi --no-doc`
2. Copy `vsphere-env.sh.sample` to `vsphere-env.sh` and update its contents
3. Run `source vsphere-env.sh`

To be able to check what Puppet sees resource-wise in your vCenter you will also need to do the following:

1. Run `sudo /opt/puppetlabs/puppet/bin/gem install rbvmomi --no-doc`
2. Run `puppet module install puppetlabs-vsphere`

You will now be able to do things like this:

- `puppet resource vsphere_vm 2>&1 |less`
- `puppet resource vsphere_vm /opdx1/vm/ops/development/pe-compiler-foo-1`
- `puppet resource vsphere_vm /opdx1/vm/ops/development/pe-compiler-foo-1 ensure=stopped`
- `puppet resource vsphere_vm /opdx1/vm/ops/development/pe-compiler-foo-1 ensure=absent`

## Cleanup

If you need to kill off the things created you will run commands similar to these to delete the VM:

```sh
$ puppet resource vsphere_vm /opdx1/vm/ops/development/pe-compiler-foo-1 ensure=absent
Notice: /Vsphere_vm[/opdx1/vm/ops/development/pe-compiler-foo-1]/ensure: changed running to absent
vsphere_vm { '/opdx1/vm/ops/development/pe-compiler-foo-1':
  ensure => 'absent',
}
```

Also, run `ssh pe-mom1-prod.ops.puppetlabs.net sudo puppet node purge <certname>` to clean up PuppetDB
