output "app_external_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
}

output "reddit_app_lb_ip" {
  value = "${google_compute_forwarding_rule.reddit_app_lb_rule.ip_address}"
}
