name "nova_dashboard-server"
description "Nova Dashboard Server Role"
run_list(
         "recipe[nova_dashboard::server]",
         "recipe[nova_dashboard::monitor]"
         "recipe[nova_dashboard::boot_from_volume]"
)
default_attributes()
override_attributes()

