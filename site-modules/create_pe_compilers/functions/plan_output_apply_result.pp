# from Benny (@Benny in community slack)
# https://puppetcommunity.slack.com/archives/C7GP57T50/p1568201080180400
function create_pe_compilers::plan_output_apply_result(ResultSet $resultset, Hash $formats =
{
  Hash =>
  {
    format => '%#h',
    string_formats => {
      Hash => '%#h',
      Array => '%#a',
      Struct => '%#h',
      Tuple => '%#a'
    }
  },
  Array =>
  {
    format => '%#a',
    string_formats => {
      Hash => '%#h',
      Array => '%#a',
      Struct => '%#h',
      Tuple => '%#a'
      }
  },
  Struct =>
  {
    format => '%#h',
    string_formats => {
      Hash => '%#h',
      Array => '%#a',
      Struct => '%#h',
      Tuple => '%#a'
    }
  },
  Tuple => {
    format => '%#a',
    string_formats => {
      Hash => '%#h',
      Array => '%#a',
      Struct => '%#h',
      Tuple => '%#a'
    }
  }
}) >> Undef {
  $resultset.each |$result| {
    out::message("Apply Info for ${result.target}:")
    out::message('Puppet Log Messages:')
    $result.report['logs'].each |$log| {
      $out1 = String($log, $formats)
      out::message($out1)
    }
    out::message('Puppet Ressources:')
    $result.report['resource_statuses'].each |$ressourcename, $statusobject| {
      out::message($ressourcename)
      $out2 = String($statusobject, $formats)
      out::message($out2)
    }
  }
  return undef
}
