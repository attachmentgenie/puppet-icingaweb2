# @summary
#   The Graphite module draws graphs out of time series data stored in Graphite.
#
# @note If you want to use `git` as `install_method`, the CLI `git` command has to be installed. You can manage it yourself as package resource or declare the package name in icingaweb2 class parameter `extra_packages`.
#
# @param [Enum['absent', 'present']] ensure
#   Enables or disables module.
#
# @param [String] git_repository
#   Set a git repository URL.
#
# @param [Optional[String]] git_revision
#   Set either a branch or a tag name, eg. `master` or `v1.3.2`.
#
# @param [Optional[String]] url
#   URL to your Graphite Web/API.
#
# @param [Optional[String]] user
#   A user with access to your Graphite Web via HTTP basic authentication.
#
# @param [Optional[String]] password
#   The users password.
#
# @param [Optional[String]] graphite_writer_host_name_template
#    The value of your Icinga 2 GraphiteWriter's attribute `host_name_template` (if specified).
#
# @param [Optional[String]] graphite_writer_service_name_template
#   The value of your icinga 2 GraphiteWriter's attribute `service_name_template` (if specified).
#
# @note Here the official [Graphite module documentation](https://www.icinga.com/docs/graphite/latest/) can be found.
#
# @example
#   class { 'icingaweb2::module::graphite':
#     git_revision => 'v0.9.0',
#     url          => 'https://localhost:8080'
#   }
#
class icingaweb2::module::graphite(
  String                    $git_repository,
  Enum['absent', 'present'] $ensure                                = 'present',
  Optional[String]          $git_revision                          = undef,
  Optional[String]          $url                                   = undef,
  Optional[String]          $user                                  = undef,
  Optional[String]          $password                              = undef,
  Optional[String]          $graphite_writer_host_name_template    = undef,
  Optional[String]          $graphite_writer_service_name_template = undef
){

  $conf_dir        = $::icingaweb2::globals::conf_dir
  $module_conf_dir = "${conf_dir}/modules/graphite"

  $graphite_settings = {
    'url'      => $url,
    'user'     => $user,
    'password' => $password,
  }

  $icinga_settings = {
    'graphite_writer_host_name_template'    => $graphite_writer_host_name_template,
    'graphite_writer_service_name_template' => $graphite_writer_service_name_template,
  }

  $settings = {
    'module-graphite-graphite' => {
      'section_name' => 'graphite',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($graphite_settings)
    },
    'module-graphite-icinga' => {
      'section_name' => 'icinga',
      'target'       => "${module_conf_dir}/config.ini",
      'settings'     => delete_undef_values($icinga_settings)
    }
  }

  icingaweb2::module { 'graphite':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    settings       => $settings,
  }
}
