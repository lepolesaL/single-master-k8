provisioner:

name: chef_zero

always_update_cookbooks: true

retry_on_exit_code:

- 35 # 35 is the exit code signaling that the node is rebooting

max_retries: 1

client_rb:

exit_status: :enabled # Opt-in to the standardized exit codes

client_fork: false  # Forked instances don't return the real exit code

environment: _default

chef_license: accept

product_name: chef