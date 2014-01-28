# Create all virtual hosts from hiera
#
#
# === Examples
#
# class { 'monophylizer::instances': }
#
#
class monophylizer::instances (
  $instances,
)
{
  create_resources('apache::vhost', $instances)
}
