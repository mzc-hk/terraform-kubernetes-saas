locals {
   groundcover = merge(
        local.helm_defaults,
        {
          name                   = local.helm_dependencies[index(local.helm_dependencies.*.name, "groundcover")].name
          chart                  = local.helm_dependencies[index(local.helm_dependencies.*.name, "groundcover")].chart
          repository             = local.helm_dependencies[index(local.helm_dependencies.*.name, "groundcover")].repository
          chart_version          = local.helm_dependencies[index(local.helm_dependencies.*.name, "groundcover")].version
          namespace              = "groundcover"
          enabled                = true
          allowed_cidrs          = ["0.0.0.0/0"]
          default_network_policy = true
          manage_crds            = true
        },
        var.groundcover
    )
    
    values_groundcover = <<VALUES
VALUES
}

resource "kubernetes_namespace" "groundcover" {
  count = local.groundcover["enabled"] ? 1 : 0

  metadata {
    labels = {
      name                               = local.groundcover["namespace"]
      "${local.labels_prefix}/component" = "groundcover"
    }

    name = local.groundcover["namespace"]
  }
}
resource "helm_release" "groundcover" {
    count                   = local.groundcover["enabled"] ? 1 : 0
    repository              = local.groundcover["repository"]
    name                    = local.groundcover["name"]
    chart                   = local.groundcover["chart"]
    version                 = local.groundcover["chart_version"]
    timeout                 = local.groundcover["timeout"]
    force_update            = local.groundcover["force_update"]
    recreate_pods           = local.groundcover["recreate_pods"]
    wait                    = local.groundcover["wait"]
    atomic                  = local.groundcover["atomic"]
    cleanup_on_fail         = local.groundcover["cleanup_on_fail"]
    dependency_update       = local.groundcover["dependency_update"]
    disable_crd_hooks       = local.groundcover["disable_crd_hooks"]
    disable_webhooks        = local.groundcover["disable_webhooks"]
    render_subchart_notes   = local.groundcover["render_subchart_notes"]
    replace                 = local.groundcover["replace"]
    reset_values            = local.groundcover["reset_values"]
    reuse_values            = local.groundcover["reuse_values"]
    skip_crds               = local.groundcover["skip_crds"]
    verify                  = local.groundcover["verify"]
    values                  = []
    namespace               = local.groundcover["create_ns"] ? kubernetes_namespace.groundcover.*.metadata.0.name[count.index] : local.groundcover["namespace"]
    
    set {
        name  = "global.groundcover_token"
        value = local.groundcover["token"]
    }
    set {
        name  = "clusterId"
        value = local.groundcover["cluster-name"]
    }
}